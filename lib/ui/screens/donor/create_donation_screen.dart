import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';
import '../../../data/models/donation.dart';
import '../../../services/appwrite_notification_service.dart';

class CreateDonationScreen extends ConsumerStatefulWidget {
  const CreateDonationScreen({super.key});

  @override
  ConsumerState<CreateDonationScreen> createState() =>
      _CreateDonationScreenState();
}

class _CreateDonationScreenState extends ConsumerState<CreateDonationScreen> {
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
  final double _latitude = 0;
  final double _longitude = 0;
  bool _isLoading = false;

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

  Future<void> _createDonation() async {
    if (!_formKey.currentState!.validate()) return;

    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final donation = Donation(
        id: '',
        donorId: user.$id,
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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(donationRepositoryProvider).createDonation(donation);
      ref.invalidate(myDonationsProvider);

      // Show immediate local notification
      await AppwriteNotificationService.instance.showNotification(
        id: (DateTime.now().millisecondsSinceEpoch % 2147483647).toInt(),
        title: 'Donation Created Successfully!',
        body:
            'Your "${donation.title}" donation has been posted and volunteers/recipients will be notified.',
        data: {'type': 'donation_created', 'donation_id': donation.id},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Donation created successfully! Volunteers and recipients have been notified.',
            ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Create Donation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                      ),
                      isExpanded: true,
                      items: _units
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
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
                onPressed: _isLoading ? null : _createDonation,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Donation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
