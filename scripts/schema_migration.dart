import 'dart:io';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

/// Result of a migration operation
class MigrationResult {
  final int recordsProcessed;
  final int recordsUpdated;
  final List<String> errors;
  final bool success;
  final DateTime startTime;
  final DateTime endTime;

  MigrationResult({
    required this.recordsProcessed,
    required this.recordsUpdated,
    required this.errors,
    required this.success,
    required this.startTime,
    required this.endTime,
  });

  Duration get duration => endTime.difference(startTime);

  Map<String, dynamic> toJson() => {
    'recordsProcessed': recordsProcessed,
    'recordsUpdated': recordsUpdated,
    'errors': errors,
    'success': success,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'durationSeconds': duration.inSeconds,
  };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Migration Result:');
    buffer.writeln('  Status: ${success ? "SUCCESS" : "FAILED"}');
    buffer.writeln('  Records Processed: $recordsProcessed');
    buffer.writeln('  Records Updated: $recordsUpdated');
    buffer.writeln('  Duration: ${duration.inSeconds}s');
    if (errors.isNotEmpty) {
      buffer.writeln('  Errors (${errors.length}):');
      for (final error in errors) {
        buffer.writeln('    - $error');
      }
    }
    return buffer.toString();
  }
}

/// Result of a validation operation
class ValidationResult {
  final String checkName;
  final bool passed;
  final String? message;
  final List<String> details;

  ValidationResult({
    required this.checkName,
    required this.passed,
    this.message,
    this.details = const [],
  });

  Map<String, dynamic> toJson() => {
    'checkName': checkName,
    'passed': passed,
    'message': message,
    'details': details,
  };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Validation: $checkName');
    buffer.writeln('  Status: ${passed ? "PASSED" : "FAILED"}');
    if (message != null) {
      buffer.writeln('  Message: $message');
    }
    if (details.isNotEmpty) {
      buffer.writeln('  Details:');
      for (final detail in details) {
        buffer.writeln('    - $detail');
      }
    }
    return buffer.toString();
  }
}

/// Configuration for migration operations
class MigrationConfig {
  final bool dryRun;
  final bool createBackup;
  final bool verbose;
  final String? backupPath;
  final int batchSize;

  MigrationConfig({
    this.dryRun = false,
    this.createBackup = true,
    this.verbose = false,
    this.backupPath,
    this.batchSize = 100,
  });

  @override
  String toString() {
    return 'MigrationConfig(dryRun: $dryRun, createBackup: $createBackup, '
        'verbose: $verbose, backupPath: $backupPath, batchSize: $batchSize)';
  }
}

/// Base class for schema migrations
class SchemaMigration {
  final Client client;
  final TablesDB tablesDB;
  final String databaseId;
  final MigrationConfig config;

  SchemaMigration({
    required this.client,
    required this.databaseId,
    required this.config,
  }) : tablesDB = TablesDB(client);

  /// Initialize Appwrite client from environment variables
  /// Note: For server-side operations, we need to use API key authentication
  static Client initializeClient({
    required String endpoint,
    required String projectId,
    required String apiKey,
  }) {
    final client = Client().setEndpoint(endpoint).setProject(projectId);

    // Set API key in headers for server-side authentication
    client.addHeader('X-Appwrite-Key', apiKey);

    return client;
  }

  /// Create a backup of a collection to a JSON file
  Future<String> createBackup(String collectionId, String backupName) async {
    if (!config.createBackup) {
      _log('Backup disabled, skipping...');
      return '';
    }

    _log('Creating backup for collection: $collectionId');

    try {
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupDir = config.backupPath ?? 'backups';
      final backupFile = '$backupDir/${backupName}_$timestamp.json';

      // Create backup directory if it doesn't exist
      final dir = Directory(backupDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Fetch all documents from the collection
      final documents = await _fetchAllDocuments(collectionId);

      // Write to file
      final file = File(backupFile);
      final jsonData = {
        'collectionId': collectionId,
        'timestamp': timestamp,
        'documentCount': documents.length,
        'documents': documents.map((doc) => doc.data).toList(),
      };

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(jsonData),
      );

      _log('Backup created: $backupFile (${documents.length} documents)');
      return backupFile;
    } catch (e) {
      _log('Error creating backup: $e', isError: true);
      rethrow;
    }
  }

  /// Fetch all documents from a collection (handles pagination)
  Future<List<models.Row>> _fetchAllDocuments(String collectionId) async {
    final allDocuments = <models.Row>[];
    String? lastId;
    bool hasMore = true;

    while (hasMore) {
      final queries = <String>['limit(${config.batchSize})'];

      if (lastId != null) {
        queries.add('cursorAfter("$lastId")');
      }

      final response = await tablesDB.listRows(
        databaseId: databaseId,
        tableId: collectionId,
        queries: queries,
      );

      allDocuments.addAll(response.rows);

      if (response.rows.length < config.batchSize) {
        hasMore = false;
      } else {
        lastId = response.rows.last.$id;
      }

      _log('Fetched ${allDocuments.length} documents...');
    }

    return allDocuments;
  }

  /// Update a document in the database
  Future<bool> updateDocument(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    if (config.dryRun) {
      _log('DRY RUN: Would update document $documentId with: $data');
      return true;
    }

    try {
      await tablesDB.updateRow(
        databaseId: databaseId,
        tableId: collectionId,
        rowId: documentId,
        data: data,
      );
      return true;
    } catch (e) {
      _log('Error updating document $documentId: $e', isError: true);
      return false;
    }
  }

  /// Log a message (respects verbose flag)
  void _log(String message, {bool isError = false}) {
    if (config.verbose || isError) {
      final prefix = isError ? '[ERROR]' : '[INFO]';
      final timestamp = DateTime.now().toIso8601String();
      print('$timestamp $prefix $message');
    }
  }

  /// Migrate NGO requests food category from camelCase to snake_case
  Future<MigrationResult> migrateNgoRequestsFoodCategory() async {
    final startTime = DateTime.now();
    _log('Starting NGO requests food category migration...');

    // Mapping from camelCase to snake_case
    const foodCategoryMapping = {
      'freshProduce': 'fresh_produce',
      'dairy': 'dairy',
      'meat': 'meat',
      'bakery': 'bakery',
      'canned': 'canned',
      'prepared': 'prepared',
      'other': 'other',
    };

    int recordsProcessed = 0;
    int recordsUpdated = 0;
    final errors = <String>[];

    try {
      // Create backup
      if (config.createBackup) {
        await createBackup('ngo_requests', 'ngo_requests_food_category');
      }

      // Fetch all NGO request documents
      _log('Fetching NGO request documents...');
      final documents = await _fetchAllDocuments('ngo_requests');
      _log('Found ${documents.length} NGO request documents');

      // Process each document
      for (final doc in documents) {
        recordsProcessed++;

        try {
          final currentCategory = doc.data['food_category'] as String?;

          if (currentCategory == null) {
            _log('Document ${doc.$id} has no food_category, skipping');
            continue;
          }

          // Check if conversion is needed
          final newCategory = foodCategoryMapping[currentCategory];

          if (newCategory != null && newCategory != currentCategory) {
            _log('Converting ${doc.$id}: $currentCategory -> $newCategory');

            final success = await updateDocument('ngo_requests', doc.$id, {
              'food_category': newCategory,
            });

            if (success) {
              recordsUpdated++;
            } else {
              errors.add('Failed to update document ${doc.$id}');
            }
          } else if (newCategory == null) {
            _log('Unknown food category "$currentCategory" in ${doc.$id}');
            errors.add(
              'Unknown food category "$currentCategory" in ${doc.$id}',
            );
          }
        } catch (e) {
          final error = 'Error processing document ${doc.$id}: $e';
          _log(error, isError: true);
          errors.add(error);
        }
      }

      final endTime = DateTime.now();
      final result = MigrationResult(
        recordsProcessed: recordsProcessed,
        recordsUpdated: recordsUpdated,
        errors: errors,
        success: errors.isEmpty,
        startTime: startTime,
        endTime: endTime,
      );

      _log(result.toString());
      return result;
    } catch (e) {
      final endTime = DateTime.now();
      final error = 'Migration failed: $e';
      _log(error, isError: true);
      errors.add(error);

      return MigrationResult(
        recordsProcessed: recordsProcessed,
        recordsUpdated: recordsUpdated,
        errors: errors,
        success: false,
        startTime: startTime,
        endTime: endTime,
      );
    }
  }

  /// Migrate deliveries recipient_id from empty string to null
  Future<MigrationResult> migrateDeliveriesRecipientId() async {
    final startTime = DateTime.now();
    _log('Starting deliveries recipient_id migration...');

    int recordsProcessed = 0;
    int recordsUpdated = 0;
    final errors = <String>[];

    try {
      // Create backup
      if (config.createBackup) {
        await createBackup('deliveries', 'deliveries_recipient_id');
      }

      // Fetch all delivery documents
      _log('Fetching delivery documents...');
      final documents = await _fetchAllDocuments('deliveries');
      _log('Found ${documents.length} delivery documents');

      // Process each document
      for (final doc in documents) {
        recordsProcessed++;

        try {
          final recipientId = doc.data['recipient_id'];

          // Check if recipient_id is an empty string
          if (recipientId is String && recipientId.isEmpty) {
            _log('Converting ${doc.$id}: empty string -> null');

            final success = await updateDocument('deliveries', doc.$id, {
              'recipient_id': null,
            });

            if (success) {
              recordsUpdated++;
            } else {
              errors.add('Failed to update document ${doc.$id}');
            }
          }
        } catch (e) {
          final error = 'Error processing document ${doc.$id}: $e';
          _log(error, isError: true);
          errors.add(error);
        }
      }

      final endTime = DateTime.now();
      final result = MigrationResult(
        recordsProcessed: recordsProcessed,
        recordsUpdated: recordsUpdated,
        errors: errors,
        success: errors.isEmpty,
        startTime: startTime,
        endTime: endTime,
      );

      _log(result.toString());
      return result;
    } catch (e) {
      final endTime = DateTime.now();
      final error = 'Migration failed: $e';
      _log(error, isError: true);
      errors.add(error);

      return MigrationResult(
        recordsProcessed: recordsProcessed,
        recordsUpdated: recordsUpdated,
        errors: errors,
        success: false,
        startTime: startTime,
        endTime: endTime,
      );
    }
  }

  /// Validate the migration results
  Future<List<ValidationResult>> validateMigration() async {
    _log('Starting migration validation...');

    final results = <ValidationResult>[];

    // Validate NGO requests food category
    results.add(await _validateNgoRequestsFoodCategory());

    // Validate deliveries recipient_id
    results.add(await _validateDeliveriesRecipientId());

    return results;
  }

  /// Validate NGO requests food category values
  Future<ValidationResult> _validateNgoRequestsFoodCategory() async {
    _log('Validating NGO requests food category...');

    const validCategories = [
      'fresh_produce',
      'dairy',
      'meat',
      'bakery',
      'canned',
      'prepared',
      'other',
    ];

    try {
      final documents = await _fetchAllDocuments('ngo_requests');
      final invalidRecords = <String>[];

      for (final doc in documents) {
        final category = doc.data['food_category'] as String?;

        if (category == null) {
          invalidRecords.add('${doc.$id}: null food_category');
        } else if (!validCategories.contains(category)) {
          invalidRecords.add('${doc.$id}: invalid category "$category"');
        }
      }

      if (invalidRecords.isEmpty) {
        return ValidationResult(
          checkName: 'NGO Requests Food Category',
          passed: true,
          message:
              'All ${documents.length} records have valid snake_case food categories',
        );
      } else {
        return ValidationResult(
          checkName: 'NGO Requests Food Category',
          passed: false,
          message:
              'Found ${invalidRecords.length} records with invalid food categories',
          details: invalidRecords,
        );
      }
    } catch (e) {
      return ValidationResult(
        checkName: 'NGO Requests Food Category',
        passed: false,
        message: 'Validation failed: $e',
      );
    }
  }

  /// Validate deliveries recipient_id values
  Future<ValidationResult> _validateDeliveriesRecipientId() async {
    _log('Validating deliveries recipient_id...');

    try {
      final documents = await _fetchAllDocuments('deliveries');
      final invalidRecords = <String>[];

      for (final doc in documents) {
        final recipientId = doc.data['recipient_id'];

        // Check if recipient_id is an empty string (should be null or non-empty)
        if (recipientId is String && recipientId.isEmpty) {
          invalidRecords.add('${doc.$id}: empty string recipient_id');
        }
      }

      if (invalidRecords.isEmpty) {
        return ValidationResult(
          checkName: 'Deliveries Recipient ID',
          passed: true,
          message:
              'All ${documents.length} records have valid recipient_id (null or non-empty string)',
        );
      } else {
        return ValidationResult(
          checkName: 'Deliveries Recipient ID',
          passed: false,
          message:
              'Found ${invalidRecords.length} records with empty string recipient_id',
          details: invalidRecords,
        );
      }
    } catch (e) {
      return ValidationResult(
        checkName: 'Deliveries Recipient ID',
        passed: false,
        message: 'Validation failed: $e',
      );
    }
  }
}

/// Parse command-line arguments
class MigrationArgs {
  final bool dryRun;
  final bool createBackup;
  final bool verbose;
  final String? backupPath;
  final int batchSize;
  final String operation;
  final bool help;

  MigrationArgs({
    this.dryRun = false,
    this.createBackup = true,
    this.verbose = false,
    this.backupPath,
    this.batchSize = 100,
    this.operation = 'all',
    this.help = false,
  });

  static MigrationArgs parse(List<String> args) {
    bool dryRun = false;
    bool createBackup = true;
    bool verbose = false;
    String? backupPath;
    int batchSize = 100;
    String operation = 'all';
    bool help = false;

    for (int i = 0; i < args.length; i++) {
      final arg = args[i];

      switch (arg) {
        case '--dry-run':
        case '-d':
          dryRun = true;
          break;
        case '--no-backup':
          createBackup = false;
          break;
        case '--verbose':
        case '-v':
          verbose = true;
          break;
        case '--backup-path':
          if (i + 1 < args.length) {
            backupPath = args[++i];
          }
          break;
        case '--batch-size':
          if (i + 1 < args.length) {
            batchSize = int.tryParse(args[++i]) ?? 100;
          }
          break;
        case '--operation':
        case '-o':
          if (i + 1 < args.length) {
            operation = args[++i];
          }
          break;
        case '--help':
        case '-h':
          help = true;
          break;
      }
    }

    return MigrationArgs(
      dryRun: dryRun,
      createBackup: createBackup,
      verbose: verbose,
      backupPath: backupPath,
      batchSize: batchSize,
      operation: operation,
      help: help,
    );
  }

  static void printHelp() {
    print('''
Schema Migration Script

Usage: dart scripts/schema_migration.dart [options]

Options:
  --dry-run, -d           Run migration without making changes
  --no-backup             Skip creating backups before migration
  --verbose, -v           Enable verbose logging
  --backup-path <path>    Custom path for backup files (default: backups/)
  --batch-size <size>     Number of documents to fetch per batch (default: 100)
  --operation, -o <op>    Operation to perform (default: all)
                          Options: all, ngo-requests, deliveries, validate
  --help, -h              Show this help message

Examples:
  # Run all migrations with dry-run
  dart scripts/schema_migration.dart --dry-run --verbose

  # Run only NGO requests migration
  dart scripts/schema_migration.dart --operation ngo-requests

  # Run validation only
  dart scripts/schema_migration.dart --operation validate

  # Run with custom backup path
  dart scripts/schema_migration.dart --backup-path ./my-backups
''');
  }
}

/// Main entry point
Future<void> main(List<String> args) async {
  final parsedArgs = MigrationArgs.parse(args);

  if (parsedArgs.help) {
    MigrationArgs.printHelp();
    exit(0);
  }

  print('=== Schema Migration Script ===\n');

  // Load environment variables
  final envFile = File('.env');
  if (!await envFile.exists()) {
    print('ERROR: .env file not found');
    exit(1);
  }

  final envContent = await envFile.readAsString();
  final envVars = <String, String>{};

  for (final line in envContent.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

    final parts = trimmed.split('=');
    if (parts.length >= 2) {
      final key = parts[0].trim();
      final value = parts.sublist(1).join('=').trim();
      envVars[key] = value;
    }
  }

  final endpoint = envVars['APPWRITE_ENDPOINT'];
  final projectId = envVars['APPWRITE_PROJECT_ID'];
  final apiKey = envVars['APPWRITE_API_KEY'];
  final databaseId = envVars['APPWRITE_DATABASE_ID'];

  if (endpoint == null ||
      projectId == null ||
      apiKey == null ||
      databaseId == null) {
    print('ERROR: Missing required environment variables');
    print(
      'Required: APPWRITE_ENDPOINT, APPWRITE_PROJECT_ID, APPWRITE_API_KEY, APPWRITE_DATABASE_ID',
    );
    exit(1);
  }

  // Initialize client
  final client = SchemaMigration.initializeClient(
    endpoint: endpoint,
    projectId: projectId,
    apiKey: apiKey,
  );

  // Create migration config
  final config = MigrationConfig(
    dryRun: parsedArgs.dryRun,
    createBackup: parsedArgs.createBackup,
    verbose: parsedArgs.verbose,
    backupPath: parsedArgs.backupPath,
    batchSize: parsedArgs.batchSize,
  );

  print('Configuration:');
  print('  $config\n');

  if (parsedArgs.dryRun) {
    print('⚠️  DRY RUN MODE - No changes will be made\n');
  }

  // Create migration instance
  final migration = SchemaMigration(
    client: client,
    databaseId: databaseId,
    config: config,
  );

  try {
    // Execute requested operation
    switch (parsedArgs.operation.toLowerCase()) {
      case 'ngo-requests':
        print('Running NGO requests food category migration...\n');
        final result = await migration.migrateNgoRequestsFoodCategory();
        print('\n$result');
        exit(result.success ? 0 : 1);

      case 'deliveries':
        print('Running deliveries recipient_id migration...\n');
        final result = await migration.migrateDeliveriesRecipientId();
        print('\n$result');
        exit(result.success ? 0 : 1);

      case 'validate':
        print('Running validation...\n');
        final results = await migration.validateMigration();
        print('\n=== Validation Results ===\n');
        for (final result in results) {
          print(result);
          print('');
        }
        final allPassed = results.every((r) => r.passed);
        exit(allPassed ? 0 : 1);

      case 'all':
      default:
        print('Running all migrations...\n');

        // Run NGO requests migration
        print('1. NGO Requests Food Category Migration');
        print('=' * 50);
        final ngoResult = await migration.migrateNgoRequestsFoodCategory();
        print('\n$ngoResult\n');

        // Run deliveries migration
        print('2. Deliveries Recipient ID Migration');
        print('=' * 50);
        final deliveriesResult = await migration.migrateDeliveriesRecipientId();
        print('\n$deliveriesResult\n');

        // Run validation
        print('3. Validation');
        print('=' * 50);
        final validationResults = await migration.validateMigration();
        for (final result in validationResults) {
          print(result);
          print('');
        }

        // Summary
        print('=' * 50);
        print('SUMMARY');
        print('=' * 50);
        print('NGO Requests: ${ngoResult.success ? "✓ SUCCESS" : "✗ FAILED"}');
        print(
          'Deliveries: ${deliveriesResult.success ? "✓ SUCCESS" : "✗ FAILED"}',
        );
        final allValidationsPassed = validationResults.every((r) => r.passed);
        print('Validation: ${allValidationsPassed ? "✓ PASSED" : "✗ FAILED"}');

        final overallSuccess =
            ngoResult.success &&
            deliveriesResult.success &&
            allValidationsPassed;
        exit(overallSuccess ? 0 : 1);
    }
  } catch (e) {
    print('\nERROR: $e');
    exit(1);
  }
}
