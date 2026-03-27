import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';
import '../../../data/models/donation.dart';

class EditDonationScreen extends ConsumerStatefulWidget {
  final String donationId;

  const EditDonationScreen({super.key, required this.donationId});

  @override
  ConsumerState<EditDonationScreen> createState() => _EditDonationScreenState();
}

class _EditDonationScreenState extends ConsumerState<EditDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();

  FoodCategory _selectedCategory = FoodCategory.other;
  String _selectedUnit = 'kg';
  DateTime _expirationDate = DateTime.now().add(const Duration(days: 3));
  DateTime _pickupStartTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _pickupEndTime = DateTime.now().add(const Duration(hours: 4));
  double _latitude = 0;
  double _longitude = 0;
  bool _isLoading = false;
  bool _isInitialized = false;

  final List<String> _units = ['kg', 'lbs', 'items', 'boxes', 'bags', 'liters'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _initializeForm(Donation donation) {
    if (_isInitialized) return;

    _titleController.text = donation.title;
    _descriptionController.text = donation.description ?? '';
    _quantityController.text = donation.quantity.toString();
    _addressController.text = donation.pickupAddress;
    _instructionsController.text = donation.specialInstructions ?? '';

    _selectedCategory = donation.foodCategory;
    _selectedUnit = donation.unit;
    _expirationDate = donation.expirationDate;
    _pickupStartTime = donation.pickupStartTime;
    _pickupEndTime = donation.pickupEndTime;
    _latitude = donation.latitude;
    _longitude = donation.longitude;

    _isInitialized = true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _expirationDate = picked);
  }

  Future<void> _selectPickupTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _pickupStartTime : _pickupEndTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        isStart ? _pickupStartTime : _pickupEndTime,
      ),
    );
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        _pickupStartTime = dateTime;
      } else {
        _pickupEndTime = dateTime;
      }
    });
  }

  Future<void> _updateDonation(Donation originalDonation) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedDonation = originalDonation.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        foodCategory: _selectedCategory,
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        expirationDate: _expirationDate,
        pickupAddress: _addressController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        pickupStartTime: _pickupStartTime,
        pickupEndTime: _pickupEndTime,
        specialInstructions: _instructionsController.text.trim(),
      );

      await ref
          .read(donationRepositoryProvider)
          .updateDonation(updatedDonation);

      // Invalidate providers to refresh data
      ref.invalidate(donationProvider(widget.donationId));
      ref.invalidate(myDonationsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationAsync = ref.watch(donationProvider(widget.donationId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Donation')),
      body: donationAsync.when(
        data: (donation) {
          _initializeForm(donation);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Warning if donation is already assigned
                  if (donation.assignedVolunteerId != null ||
                      donation.assignedRecipientId != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This donation has been assigned. Changes may affect the delivery.',
                              style: TextStyle(color: Colors.orange[300]),
                            ),
                          ),
                        ],
                      ),
                    ),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<FoodCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Food Category',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: FoodCategory.values
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.displayName),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            prefixIcon: Icon(Icons.scale),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedUnit,
                          decoration: const InputDecoration(labelText: 'Unit'),
                          items: _units
                              .map(
                                (u) =>
                                    DropdownMenuItem(value: u, child: Text(u)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _selectedUnit = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Expiration Date'),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(_expirationDate),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const Divider(),

                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Pickup Address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time),
                    title: const Text('Pickup Window'),
                    subtitle: Text(
                      '${DateFormat('MMM dd, HH:mm').format(_pickupStartTime)} - ${DateFormat('HH:mm').format(_pickupEndTime)}',
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectPickupTime(true),
                          child: const Text('Start Time'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectPickupTime(false),
                          child: const Text('End Time'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _instructionsController,
                    decoration: const InputDecoration(
                      labelText: 'Special Instructions',
                      prefixIcon: Icon(Icons.info),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _updateDonation(donation),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Update Donation'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading donation: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
