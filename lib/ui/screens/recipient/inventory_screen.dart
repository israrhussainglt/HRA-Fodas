import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../../../providers/providers.dart';
import '../../../data/models/inventory_item.dart';
import '../../../core/enums/enums.dart';
import '../../../appwrite_options.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  final bool embedded;

  const InventoryScreen({super.key, this.embedded = false});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FoodCategory? _selectedCategory;
  RealtimeSubscription? _inventorySubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupRealtimeSubscriptions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inventorySubscription?.close();
    super.dispose();
  }

  void _setupRealtimeSubscriptions() {
    final userAsync = ref.read(currentUserProvider);
    userAsync.whenData((user) {
      if (user != null) {
        final realtime = ref.read(appwriteRealtimeProvider);

        // Subscribe to inventory collection
        _inventorySubscription = realtime.subscribe([
          'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.inventoryCollection}.documents',
        ]);

        _inventorySubscription!.stream.listen((response) {
          if (response.events.contains(
            'databases.*.collections.*.documents.*',
          )) {
            // Refresh inventory data
            ref.invalidate(inventoryProvider(user.$id));
            ref.invalidate(expiringItemsProvider(user.$id));
            ref.invalidate(lowStockItemsProvider(user.$id));
            ref.invalidate(inventorySummaryProvider(user.$id));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return widget.embedded
              ? const Center(child: Text('Please login'))
              : const Scaffold(body: Center(child: Text('Please login')));
        }

        final content = Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'All Items'),
                  Tab(text: 'Expiring Soon'),
                  Tab(text: 'Low Stock'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _AllItemsTab(userId: user.$id, category: _selectedCategory),
                  _ExpiringItemsTab(userId: user.$id),
                  _LowStockTab(userId: user.$id),
                ],
              ),
            ),
          ],
        );

        if (widget.embedded) {
          return Stack(
            children: [
              content,
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () => _showAddItemDialog(context, user.$id),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Inventory'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(inventoryProvider);
                  ref.invalidate(expiringItemsProvider);
                  ref.invalidate(lowStockItemsProvider);
                  ref.invalidate(inventorySummaryProvider);
                },
                tooltip: 'Refresh Inventory',
              ),
              PopupMenuButton<FoodCategory?>(
                icon: const Icon(Icons.filter_list),
                onSelected: (category) =>
                    setState(() => _selectedCategory = category),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: null,
                    child: Text('All Categories'),
                  ),
                  ...FoodCategory.values.map(
                    (c) => PopupMenuItem(value: c, child: Text(c.displayName)),
                  ),
                ],
              ),
            ],
          ),
          body: content,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddItemDialog(context, user.$id),
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () => widget.embedded
          ? const Center(child: CircularProgressIndicator())
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => widget.embedded
          ? Center(child: Text('Error: $e'))
          : Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  void _showAddItemDialog(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddInventoryItemSheet(recipientId: userId),
    );
  }
}

class _AllItemsTab extends ConsumerWidget {
  final String userId;
  final FoodCategory? category;

  const _AllItemsTab({required this.userId, this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryProvider(userId));

    return inventoryAsync.when(
      data: (items) {
        final filtered = category == null
            ? items
            : items.where((i) => i.category == category).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No items in inventory'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) =>
              _InventoryItemCard(item: filtered[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _ExpiringItemsTab extends ConsumerWidget {
  final String userId;

  const _ExpiringItemsTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expiringAsync = ref.watch(expiringItemsProvider(userId));

    return expiringAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('No items expiring soon!'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) =>
              _InventoryItemCard(item: items[index], showExpiryWarning: true),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _LowStockTab extends ConsumerWidget {
  final String userId;

  const _LowStockTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowStockAsync = ref.watch(lowStockItemsProvider(userId));

    return lowStockAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('All items well stocked!'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) =>
              _InventoryItemCard(item: items[index], showLowStockWarning: true),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _InventoryItemCard extends ConsumerWidget {
  final InventoryItem item;
  final bool showExpiryWarning;
  final bool showLowStockWarning;

  const _InventoryItemCard({
    required this.item,
    this.showExpiryWarning = false,
    this.showLowStockWarning = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysUntilExpiry = item.expirationDate
        .difference(DateTime.now())
        .inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.category.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                if (showExpiryWarning || daysUntilExpiry <= 3)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      daysUntilExpiry <= 0
                          ? 'Expired!'
                          : '$daysUntilExpiry days left',
                      style: TextStyle(
                        fontSize: 12,
                        color: daysUntilExpiry <= 0
                            ? Colors.red
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (showLowStockWarning)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Low Stock',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${item.quantity} ${item.unit}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Expires: ${item.expirationDate.day}/${item.expirationDate.month}/${item.expirationDate.year}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showEditQuantityDialog(context, ref, item),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Update'),
                ),
                TextButton.icon(
                  onPressed: () => _confirmDelete(context, ref, item),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditQuantityDialog(
    BuildContext context,
    WidgetRef ref,
    InventoryItem item,
  ) {
    final controller = TextEditingController(text: item.quantity.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Quantity'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Quantity (${item.unit})',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final newQty = double.tryParse(controller.text);
              if (newQty != null) {
                await ref
                    .read(inventoryRepositoryProvider)
                    .updateQuantity(item.id, newQty);

                // Invalidate all inventory providers to refresh the data
                ref.invalidate(inventoryProvider);
                ref.invalidate(expiringItemsProvider);
                ref.invalidate(lowStockItemsProvider);
                ref.invalidate(inventorySummaryProvider);

                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text(
          'Are you sure you want to remove "${item.name}" from inventory?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ref
                  .read(inventoryRepositoryProvider)
                  .deleteInventoryItem(item.id);

              // Invalidate all inventory providers to refresh the data
              ref.invalidate(inventoryProvider);
              ref.invalidate(expiringItemsProvider);
              ref.invalidate(lowStockItemsProvider);
              ref.invalidate(inventorySummaryProvider);

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _AddInventoryItemSheet extends ConsumerStatefulWidget {
  final String recipientId;

  const _AddInventoryItemSheet({required this.recipientId});

  @override
  ConsumerState<_AddInventoryItemSheet> createState() =>
      _AddInventoryItemSheetState();
}

class _AddInventoryItemSheetState
    extends ConsumerState<_AddInventoryItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController(text: 'kg');
  FoodCategory _category = FoodCategory.other;
  DateTime _expirationDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Inventory Item',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<FoodCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: FoodCategory.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Expiration Date'),
                subtitle: Text(
                  '${_expirationDate.day}/${_expirationDate.month}/${_expirationDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _expirationDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _expirationDate = date);
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Item'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final item = InventoryItem(
        id: '',
        recipientId: widget.recipientId,
        name: _nameController.text,
        category: _category,
        quantity: double.parse(_quantityController.text),
        unit: _unitController.text,
        expirationDate: _expirationDate,
        receivedDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      print('[INVENTORY_SCREEN] Attempting to add item: ${item.name}');
      final result = await ref.read(inventoryRepositoryProvider).addInventoryItem(item);
      
      if (result == null) {
        throw Exception('Failed to add item - repository returned null');
      }
      
      print('[INVENTORY_SCREEN] Item added successfully: ${result.id}');

      // Invalidate all inventory providers to refresh the data
      ref.invalidate(inventoryProvider);
      ref.invalidate(expiringItemsProvider);
      ref.invalidate(lowStockItemsProvider);
      ref.invalidate(inventorySummaryProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')),
        );
        Navigator.pop(context);
      }
    } on AppwriteException catch (e) {
      print('[INVENTORY_SCREEN] Appwrite error: ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appwrite Error: ${e.message ?? "Unknown error"}')),
        );
      }
    } catch (e, stackTrace) {
      print('[INVENTORY_SCREEN] Error adding item: $e');
      print('[INVENTORY_SCREEN] Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
