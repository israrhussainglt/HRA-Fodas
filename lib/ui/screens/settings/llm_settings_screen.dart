import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/meal_planner_providers.dart';

class LLMSettingsScreen extends ConsumerStatefulWidget {
  const LLMSettingsScreen({super.key});

  @override
  ConsumerState<LLMSettingsScreen> createState() => _LLMSettingsScreenState();
}

class _LLMSettingsScreenState extends ConsumerState<LLMSettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _isLoading = false;
  bool _isTestingConnection = false;
  bool _connectionSuccess = false;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('openrouter_api_key') ?? '';

    setState(() {
      _apiKeyController.text = apiKey;
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('openrouter_api_key', _apiKeyController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testConnection() async {
    if (_apiKeyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your OpenRouter API key'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _connectionSuccess = false;
      _connectionError = null;
    });

    try {
      // Save the API key first
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('openrouter_api_key', _apiKeyController.text);

      // Load the API key into the service
      final openRouterService = ref.read(openRouterServiceProvider);
      await openRouterService.loadApiKey();

      // Test the connection
      final success = await openRouterService.testConnection();

      setState(() {
        _connectionSuccess = success;
        if (!success) {
          _connectionError = 'Could not connect to OpenRouter API';
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Connection successful!'
                  : 'Connection failed. Please check your API key.',
            ),
            backgroundColor: success
                ? AppTheme.successColor
                : AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _connectionSuccess = false;
        _connectionError = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error testing connection: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      setState(() => _isTestingConnection = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableModels = ref.watch(availableModelsProvider);
    final selectedModel = ref.watch(selectedModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'OpenRouter API Configuration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure your OpenRouter API key to use AI meal planning from anywhere',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // API Key Input
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                prefixIcon: Icon(Icons.key),
                border: OutlineInputBorder(),
                helperText: 'Get your API key from openrouter.ai/keys',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Test Connection Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isTestingConnection ? null : _testConnection,
                icon: _isTestingConnection
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.wifi_tethering),
                label: Text(
                  _isTestingConnection ? 'Testing...' : 'Test Connection',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            // Connection Status
            if (_connectionSuccess || _connectionError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _connectionSuccess
                      ? AppTheme.successColor.withValues(alpha: 0.1)
                      : AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _connectionSuccess
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _connectionSuccess ? Icons.check_circle : Icons.error,
                      color: _connectionSuccess
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _connectionSuccess
                            ? 'Connected successfully!'
                            : _connectionError ?? 'Connection failed',
                        style: TextStyle(
                          color: _connectionSuccess
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveSettings,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Saving...' : 'Save Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Model Selection
            const Text(
              'AI Model Selection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedModel,
                  isExpanded: true,
                  isDense: true,
                  items: availableModels.map((model) {
                    final modelId = model['id'] as String;
                    final modelName = model['name'] as String;

                    return DropdownMenuItem(
                      value: modelId,
                      child: Text(
                        modelName,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(selectedModelProvider.notifier).state = value;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Show selected model description below
            if (availableModels.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: () {
                  final selectedModelData = availableModels.firstWhere(
                    (m) => m['id'] == selectedModel,
                    orElse: () => availableModels.first,
                  );
                  final description =
                      selectedModelData['description'] as String?;

                  return Text(
                    description ?? 'No description available',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  );
                }(),
              ),
            ],

            const SizedBox(height: 24),

            // Information Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'How to set up OpenRouter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Go to openrouter.ai and create an account',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '2. Navigate to Keys section and create a new API key',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '3. Copy the API key and paste it above',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '4. Test the connection and save',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Note: OpenRouter provides access to multiple AI models including free options. Some models may require credits.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Bottom padding for scroll
          ],
        ),
      ),
    );
  }
}
