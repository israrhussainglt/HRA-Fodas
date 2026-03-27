import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/admin_report.dart';
import '../../../providers/providers.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportType? _selectedType;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(adminReportsProvider(_selectedType));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildQuickActions(),
          const Divider(),
          Expanded(
            child: reportsAsync.when(
              data: (reports) => reports.isEmpty
                  ? _buildEmptyState()
                  : _buildReportsList(reports),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateReportDialog,
        icon: const Icon(Icons.add),
        label: const Text('Generate Report'),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Reports',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickReportChip(
                label: 'Food Collection',
                icon: Icons.restaurant,
                onTap: () => _generateQuickReport(ReportType.foodCollection),
              ),
              _QuickReportChip(
                label: 'Distribution Impact',
                icon: Icons.local_shipping,
                onTap: () =>
                    _generateQuickReport(ReportType.distributionImpact),
              ),
              _QuickReportChip(
                label: 'Volunteer Activity',
                icon: Icons.people,
                onTap: () => _generateQuickReport(ReportType.volunteerActivity),
              ),
              _QuickReportChip(
                label: 'Resource Utilization',
                icon: Icons.analytics,
                onTap: () =>
                    _generateQuickReport(ReportType.resourceUtilization),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList(List<AdminReport> reports) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(_getReportIcon(report.reportType)),
            ),
            title: Text(report.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report.description != null) Text(report.description!),
                const SizedBox(height: 4),
                Text(
                  'Generated: ${DateFormat.yMMMd().format(report.createdAt)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: _buildStatusChip(report.status),
            onTap: () => _viewReport(report),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No reports generated yet',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to create your first report',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ReportStatus status) {
    Color color;
    String label;

    switch (status) {
      case ReportStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case ReportStatus.generating:
        color = Colors.orange;
        label = 'Generating';
        break;
      case ReportStatus.failed:
        color = Colors.red;
        label = 'Failed';
        break;
      default:
        color = Colors.grey;
        label = 'Pending';
    }

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  IconData _getReportIcon(ReportType type) {
    switch (type) {
      case ReportType.foodCollection:
        return Icons.restaurant;
      case ReportType.distributionImpact:
        return Icons.local_shipping;
      case ReportType.volunteerActivity:
        return Icons.people;
      case ReportType.resourceUtilization:
        return Icons.analytics;
      case ReportType.userFeedback:
        return Icons.feedback;
      case ReportType.trustScores:
        return Icons.verified_user;
      default:
        return Icons.description;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Reports'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ReportType?>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Report Type'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Types')),
                ...ReportType.values.map(
                  (type) =>
                      DropdownMenuItem(value: type, child: Text(type.name)),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _selectedType = null);
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreateReportDialog() {
    showDialog(
      context: context,
      builder: (context) => _CreateReportDialog(
        startDate: _startDate,
        endDate: _endDate,
        onGenerate: (type, title, description, startDate, endDate) async {
          final user = await ref.read(currentUserProvider.future);
          if (user == null) return;

          await ref
              .read(adminRepositoryProvider)
              .createReport(
                reportType: type,
                title: title,
                description: description,
                generatedBy: user.$id,
                dateFrom: startDate,
                dateTo: endDate,
              );

          ref.invalidate(adminReportsProvider);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report generation started')),
            );
          }
        },
      ),
    );
  }

  void _generateQuickReport(ReportType type) async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    await ref
        .read(adminRepositoryProvider)
        .createReport(
          reportType: type,
          title:
              '${type.name} Report - ${DateFormat.yMMMd().format(DateTime.now())}',
          generatedBy: user.$id,
          dateFrom: _startDate,
          dateTo: _endDate,
        );

    ref.invalidate(adminReportsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report generation started')),
      );
    }
  }

  void _viewReport(AdminReport report) {
    // Navigate to report detail screen
    context.push('/admin/reports/${report.id}');
  }
}

class _QuickReportChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickReportChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _CreateReportDialog extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(ReportType, String, String?, DateTime, DateTime) onGenerate;

  const _CreateReportDialog({
    required this.startDate,
    required this.endDate,
    required this.onGenerate,
  });

  @override
  State<_CreateReportDialog> createState() => _CreateReportDialogState();
}

class _CreateReportDialogState extends State<_CreateReportDialog> {
  final _formKey = GlobalKey<FormState>();
  ReportType _selectedType = ReportType.foodCollection;
  late String _title;
  String? _description;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _title =
        '${_selectedType.name} Report - ${DateFormat.yMMMd().format(DateTime.now())}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate Report'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ReportType>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Report Type'),
                items: ReportType.values
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type.name)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                      _title =
                          '${value.name} Report - ${DateFormat.yMMMd().format(DateTime.now())}';
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(DateFormat.yMMMd().format(_startDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _startDate = date);
                  }
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(DateFormat.yMMMd().format(_endDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _endDate = date);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onGenerate(
                _selectedType,
                _title,
                _description,
                _startDate,
                _endDate,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Generate'),
        ),
      ],
    );
  }
}
