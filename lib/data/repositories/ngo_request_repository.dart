import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../models/ngo_request.dart';
import '../models/notification_model.dart';
import '../../core/enums/enums.dart';
import '../../appwrite_options.dart';
import '../../core/utils/logger.dart';
import 'notification_repository.dart';
import 'auth_repository.dart';

// Exception for duplicate request attempts
class DuplicateRequestException implements Exception {
  final String message;
  DuplicateRequestException(this.message);

  @override
  String toString() => message;
}

class NGORequestRepository {
  final TablesDB _databases;
  final NotificationRepository? _notificationRepository;
  final AuthRepository? _authRepository;

  NGORequestRepository(
    this._databases, {
    NotificationRepository? notificationRepository,
    AuthRepository? authRepository,
  }) : _notificationRepository = notificationRepository,
       _authRepository = authRepository;

  // ============================================
  // DUPLICATE CHECK
  // ============================================

  /// Check if an NGO has already requested a specific donation
  Future<bool> checkDuplicateRequest({
    required String ngoId,
    required String donationId,
  }) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'ngo_requests',
        queries: [
          Query.equal('recipient_id', ngoId),
          Query.equal('donation_id', donationId),
          Query.limit(1),
        ],
      );

      return response.rows.isNotEmpty;
    } on AppwriteException {
      // If query fails, assume no duplicate to allow request to proceed
      return false;
    }
  }

  // ============================================
  // CREATE NGO REQUEST
  // ============================================

  /// Sanitize user input to prevent injection attacks
  String _sanitizeInput(String input) {
    // Remove any HTML tags
    String sanitized = input.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove any script tags and their content
    sanitized = sanitized.replaceAll(
      RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, dotAll: true),
      '',
    );

    // Remove any SQL injection attempts (single quotes, double quotes, backslashes)
    sanitized = sanitized.replaceAll(RegExp(r'''['"\\]'''), '');

    // Trim whitespace
    sanitized = sanitized.trim();

    return sanitized;
  }

  /// Get user-friendly error message for common scenarios
  String _getUserFriendlyError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (errorStr.contains('permission') || errorStr.contains('unauthorized')) {
      return 'You do not have permission to perform this action.';
    }
    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'The requested resource was not found.';
    }
    if (errorStr.contains('duplicate')) {
      return 'This request already exists.';
    }

    // For unknown errors, sanitize and return generic message
    return 'An error occurred. Please try again later.';
  }

  Future<NGORequest> createRequest({
    required String ngoId,
    required String ngoName,
    required String title,
    required String description,
    required FoodCategory foodCategory,
    required double quantity,
    required String unit,
    required String deliveryAddress,
    required DateTime neededBy,
    String? donationId, // Optional link to specific donation
    Map<String, dynamic>? metadata,
  }) async {
    try {
      AppLogger.info(
        'Creating NGO request: ngo_id=$ngoId, donation_id=$donationId, category=${foodCategory.name}, quantity=$quantity',
        tag: 'NGORequest',
      );

      // Validate required fields
      if (ngoId.isEmpty) {
        throw Exception('NGO ID is required');
      }
      if (title.isEmpty) {
        throw Exception('Title is required');
      }
      if (description.isEmpty) {
        throw Exception('Description is required');
      }
      if (quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }
      if (unit.isEmpty) {
        throw Exception('Unit is required');
      }
      if (deliveryAddress.isEmpty) {
        throw Exception('Delivery address is required');
      }

      // Sanitize user-provided text fields
      final sanitizedTitle = _sanitizeInput(title);
      final sanitizedDescription = _sanitizeInput(description);
      final sanitizedUnit = _sanitizeInput(unit);

      // Validate donation_id exists if provided
      if (donationId != null && donationId.isNotEmpty) {
        try {
          await _databases.getRow(
            databaseId: AppwriteOptions.databaseId,
            tableId: 'donations',
            rowId: donationId,
          );
        } on AppwriteException catch (e) {
          if (e.code == 404) {
            AppLogger.error(
              'Donation not found: donation_id=$donationId, ngo_id=$ngoId',
              tag: 'NGORequest',
              error: e,
            );
            throw Exception('The specified donation does not exist');
          }
          rethrow;
        }
      }

      // Validate ngo_id matches authenticated user (if auth repository available)
      if (_authRepository != null) {
        try {
          final currentUser = await _authRepository.currentUser;
          if (currentUser != null && currentUser.$id != ngoId) {
            AppLogger.warning(
              'Authorization mismatch: current_user=${currentUser.$id}, requested_ngo=$ngoId',
              tag: 'NGORequest',
            );
            throw Exception(
              'You can only create requests for your own organization',
            );
          }
        } catch (e) {
          // If we can't verify, allow the request to proceed
          // The database permissions will handle authorization
          AppLogger.debug(
            'Could not verify user authorization: ngo_id=$ngoId, error=$e',
            tag: 'NGORequest',
          );
        }
      }

      // Check for duplicate request BEFORE creating
      if (donationId != null) {
        final isDuplicate = await checkDuplicateRequest(
          ngoId: ngoId,
          donationId: donationId,
        );

        if (isDuplicate) {
          AppLogger.warning(
            'Duplicate request detected: ngo_id=$ngoId, donation_id=$donationId',
            tag: 'NGORequest',
          );
          throw DuplicateRequestException(
            'You have already requested this donation',
          );
        }
      }

      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'ngo_requests',
        rowId: ID.unique(),
        data: {
          'recipient_id': ngoId,
          'ngo_name': ngoName,
          'title': sanitizedTitle,
          'description': sanitizedDescription,
          'food_category': foodCategory.dbValue, // Use singular and dbValue
          'quantity': quantity, // Use 'quantity' not 'quantity_needed'
          'unit': sanitizedUnit,
          'delivery_address': deliveryAddress,
          'needed_by': neededBy.toIso8601String(),
          'status': 'pending', // Use 'pending' not 'open'
          if (donationId != null) 'donation_id': donationId,
          if (metadata != null) 'metadata': metadata,
        },
      );

      final request = NGORequest.fromJson(
        _sanitizeData({...response.data, 'id': response.$id}),
      );

      // Attempt to create notification with retry (don't fail request if notification fails)
      _createNotificationWithRetry(request).catchError((e) {
        // Log error but don't throw - request was created successfully
      });

      // Notify all admins about new request
      await _notifyAdminsAboutNewRequest(request);

      AppLogger.success(
        'NGO request created: request_id=${request.id}, ngo_id=$ngoId, donation_id=$donationId',
        tag: 'NGORequest',
      );

      return request;
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Failed to create NGO request (Appwrite): ngo_id=$ngoId, donation_id=$donationId',
        tag: 'NGORequest',
        error: e,
      );
      throw Exception(
        _getUserFriendlyError(e.message ?? 'Failed to create request'),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create NGO request: ngo_id=$ngoId, donation_id=$donationId',
        tag: 'NGORequest',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception(_getUserFriendlyError(e.toString()));
    }
  }

  // ============================================
  // ADMIN APPROVAL/DENIAL
  // ============================================

  Future<NGORequest> approveRequest({
    required String requestId,
    required String adminId,
  }) async {
    try {
      // Get the request first to check if it's linked to a donation
      final request = await getRequestById(requestId);

      final response = await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'ngo_requests',
        rowId: requestId,
        data: {
          'status': 'approved', // Use 'approved' status
        },
      );

      final updatedRequest = NGORequest.fromJson(
        _sanitizeData({...response.data, 'id': response.$id}),
      );

      // If request is linked to a donation, assign the recipient to that donation
      if (request.donationId != null) {
        try {
          await _databases.updateRow(
            databaseId: AppwriteOptions.databaseId,
            tableId: 'donations',
            rowId: request.donationId!,
            data: {'assigned_recipient_id': request.ngoId},
          );

          // Notify volunteer if one is already assigned
          await _notifyVolunteerAboutRecipient(request);
        } catch (e) {
          // Ignore errors
        }
      }

      // Notify NGO about approval
      await _notifyNGOAboutApproval(updatedRequest);

      // Notify all admins about approval
      await _notifyAdminsAboutApproval(updatedRequest, adminId);

      return updatedRequest;
    } on AppwriteException catch (e) {
      throw Exception(
        _getUserFriendlyError(e.message ?? 'Failed to approve request'),
      );
    } catch (e) {
      throw Exception(_getUserFriendlyError(e.toString()));
    }
  }

  Future<NGORequest> denyRequest({
    required String requestId,
    required String adminId,
    required String reason,
  }) async {
    try {
      final response = await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'ngo_requests',
        rowId: requestId,
        data: {
          'status': 'denied', // Use 'denied' status
        },
      );

      final request = NGORequest.fromJson(
        _sanitizeData({...response.data, 'id': response.$id}),
      );

      // Notify NGO about denial
      await _notifyNGOAboutDenial(request);

      // Notify all admins about denial
      await _notifyAdminsAboutDenial(request, adminId);

      return request;
    } on AppwriteException catch (e) {
      throw Exception(
        _getUserFriendlyError(e.message ?? 'Failed to deny request'),
      );
    } catch (e) {
      throw Exception(_getUserFriendlyError(e.toString()));
    }
  }

  // ============================================
  // CONVERT TO DONATION
  // ============================================

  Future<NGORequest> markAsConverted({
    required String requestId,
    required String donationId,
  }) async {
    try {
      final response = await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'ngo_requests',
        rowId: requestId,
        data: {
          'status': 'fulfilled', // Mark as fulfilled when converted
          'fulfilled_quantity':
              0, // This should be updated based on actual fulfillment
        },
      );

      return NGORequest.fromJson(
        _sanitizeData({...response.data, 'id': response.$id}),
      );
    } on AppwriteException catch (e) {
      throw Exception(
        _getUserFriendlyError(e.message ?? 'Failed to mark as converted'),
      );
    } catch (e) {
      throw Exception(_getUserFriendlyError(e.toString()));
    }
  }

  // ============================================
  // QUERY METHODS
  // ============================================

  Future<List<NGORequest>> getRequests({
    String? ngoId,
    NGORequestStatus? status,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queries = <String>[
        Query.orderDesc('\$createdAt'),
        Query.limit(limit),
        Query.offset(offset),
      ];

      if (ngoId != null) {
        queries.add(Query.equal('recipient_id', ngoId));
      }

      if (status != null) {
        // Map app status to schema status
        String schemaStatus;
        switch (status) {
          case NGORequestStatus.pending:
            schemaStatus = 'pending';
            break;
          case NGORequestStatus.approved:
            schemaStatus = 'approved';
            break;
          case NGORequestStatus.denied:
            schemaStatus = 'denied';
            break;
          case NGORequestStatus.converted:
            schemaStatus = 'converted';
            break;
          case NGORequestStatus.cancelled:
            schemaStatus = 'cancelled';
            break;
        }
        queries.add(Query.equal('status', schemaStatus));
      }

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'ngo_requests',
        queries: queries,
      );

      return response.rows
          .map(
            (doc) => NGORequest.fromJson(
              _sanitizeData({...doc.data, 'id': doc.$id}),
            ),
          )
          .toList();
    } on AppwriteException catch (e) {
      throw Exception(
        _getUserFriendlyError(e.message ?? 'Failed to get requests'),
      );
    } catch (e) {
      throw Exception(_getUserFriendlyError(e.toString()));
    }
  }

  Future<NGORequest> getRequestById(String id) async {
    try {
      final response = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'ngo_requests',
        rowId: id,
      );

      return NGORequest.fromJson(
        _sanitizeData({...response.data, 'id': response.$id}),
      );
    } on AppwriteException catch (e) {
      throw Exception(
        _getUserFriendlyError(e.message ?? 'Failed to get request'),
      );
    } catch (e) {
      throw Exception(_getUserFriendlyError(e.toString()));
    }
  }

  Future<List<NGORequest>> getPendingRequests() async {
    return getRequests(status: NGORequestStatus.pending);
  }

  // ============================================
  // DATA SANITIZATION
  // ============================================

  Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    // Map schema status to app status
    String appStatus = 'pending';
    final schemaStatus = data['status'] ?? 'pending';
    switch (schemaStatus) {
      case 'pending':
        appStatus = 'pending';
        break;
      case 'approved':
        appStatus = 'approved';
        break;
      case 'denied':
        appStatus = 'denied';
        break;
      case 'converted':
        appStatus = 'converted';
        break;
      case 'cancelled':
        appStatus = 'cancelled';
        break;
      default:
        appStatus = 'pending';
        break;
    }

    // Use $id for JSON parsing (the generated code expects this key)
    final sanitized = <String, dynamic>{
      r'$id': data[r'$id'] ?? data['id'] ?? '',
      'recipient_id': data['recipient_id'] ?? '',
      'ngo_name': data['ngo_name'] ?? '',
      'title': data['title'] ?? '',
      'description': data['description'] ?? '',
      'food_category': data['food_category'] ?? 'other',
      'quantity': data['quantity'] ?? 0,
      'unit': data['unit'] ?? 'kg',
      'delivery_address': data['delivery_address'] ?? '',
      'needed_by': data['needed_by'],
      'status': appStatus,
      'donation_id': data['donation_id'],
      'denial_reason': data['denial_reason'],
      'reviewed_by': data['reviewed_by'],
      'reviewed_at': data['reviewed_at'],
      'converted_donation_id': data['converted_donation_id'],
      r'$createdAt': data[r'$createdAt'] ?? data['created_at'],
      r'$updatedAt': data[r'$updatedAt'] ?? data['updated_at'],
      'metadata': _parseMetadata(data['metadata']),
    };

    return sanitized;
  }

  /// Parse metadata field which can be either a JSON string or a Map
  Map<String, dynamic>? _parseMetadata(dynamic metadata) {
    if (metadata == null) return null;
    if (metadata is Map<String, dynamic>) return metadata;
    if (metadata is String) {
      if (metadata.isEmpty || metadata == '{}') return null;
      try {
        final parsed = jsonDecode(metadata);
        return parsed is Map<String, dynamic> ? parsed : null;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // ============================================
  // NOTIFICATION HELPERS
  // ============================================

  /// Create notification with retry logic for donor
  Future<void> _createNotificationWithRetry(
    NGORequest request, {
    int maxRetries = 3,
    bool useFallback = true,
  }) async {
    if (request.donationId == null || _notificationRepository == null) {
      AppLogger.debug(
        'Skipping notification: donationId=${request.donationId}, hasRepository=${_notificationRepository != null}',
        tag: 'NGORequest',
      );
      return;
    }

    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        AppLogger.info(
          'Creating notification for NGO request (attempt ${attempts + 1}/$maxRetries): request_id=${request.id}, donation_id=${request.donationId}',
          tag: 'NGORequest',
        );

        // Get donor ID from donation
        final donationResponse = await _databases.getRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'donations',
          rowId: request.donationId!,
        );

        final donorId = donationResponse.data['donor_id'];
        if (donorId == null) {
          AppLogger.warning(
            'No donor ID found for donation: donation_id=${request.donationId}, request_id=${request.id}',
            tag: 'NGORequest',
          );
          return; // No donor to notify
        }

        // Create bell notification for donor
        await _notificationRepository.createNotification(
          userId: donorId,
          title: 'NGO Request for Your Donation',
          body:
              '${request.ngoName} has requested your ${request.quantity} ${request.unit} of ${request.foodCategory.displayName}',
          type: NotificationType.ngoRequested,
          relatedEntityId: request.id,
          relatedEntityType: 'ngo_request',
          actorName: request.ngoName,
        );

        AppLogger.success(
          'Notification created: request_id=${request.id}, donor_id=$donorId, attempts=${attempts + 1}',
          tag: 'NGORequest',
        );

        // Success - exit retry loop
        return;
      } catch (e, stackTrace) {
        attempts++;

        AppLogger.error(
          'Notification creation failed (attempt $attempts/$maxRetries): request_id=${request.id}',
          tag: 'NGORequest',
          error: e,
          stackTrace: stackTrace,
        );

        if (attempts >= maxRetries) {
          // Log that we're using fallback
          AppLogger.warning(
            'Appwrite function failed after $maxRetries attempts. Using client-side fallback: request_id=${request.id}',
            tag: 'NGORequest',
          );

          // Client-side fallback: create notification directly
          if (useFallback) {
            try {
              final donationResponse = await _databases.getRow(
                databaseId: AppwriteOptions.databaseId,
                tableId: 'donations',
                rowId: request.donationId!,
              );

              final donorId = donationResponse.data['donor_id'];
              if (donorId != null) {
                // Create bell notification directly via client
                await _notificationRepository.createNotification(
                  userId: donorId,
                  title: 'NGO Request for Your Donation',
                  body:
                      '${request.ngoName} has requested your ${request.quantity} ${request.unit} of ${request.foodCategory.displayName}',
                  type: NotificationType.ngoRequested,
                  relatedEntityId: request.id,
                  relatedEntityType: 'ngo_request',
                  actorName: request.ngoName,
                );

                AppLogger.success(
                  'Client-side fallback notification created: request_id=${request.id}, donor_id=$donorId',
                  tag: 'NGORequest',
                );
              }
            } catch (fallbackError, fallbackStackTrace) {
              AppLogger.error(
                'Client-side fallback also failed: request_id=${request.id}',
                tag: 'NGORequest',
                error: fallbackError,
                stackTrace: fallbackStackTrace,
              );
            }
          }

          return;
        }

        // Exponential backoff: 100ms, 200ms, 400ms
        final delay = 100 * (1 << attempts);
        AppLogger.debug(
          'Retrying after ${delay}ms backoff (attempt $attempts -> ${attempts + 1})',
          tag: 'NGORequest',
        );
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }

  Future<void> _notifyAdminsAboutNewRequest(NGORequest request) async {
    if (_authRepository == null || _notificationRepository == null) return;

    try {
      final admins = await _authRepository.getUsersByRole(UserRole.admin);

      for (final admin in admins) {
        await _notificationRepository.createNotification(
          userId: admin.id,
          title: 'New NGO Request',
          body:
              '${request.ngoName} has submitted a request for ${request.quantity} ${request.unit} of ${request.foodCategory.displayName}',
          type: NotificationType.ngoRequestSubmitted,
          relatedEntityId: request.id,
          relatedEntityType: 'ngo_request',
          actorName: request.ngoName,
        );
      }
    } catch (e) {
      // Ignore notification errors
    }
  }

  Future<void> _notifyNGOAboutApproval(NGORequest request) async {
    if (_notificationRepository == null) return;

    try {
      await _notificationRepository.createNotification(
        userId: request.ngoId,
        title: 'Request Approved',
        body:
            'Your request for ${request.quantity} ${request.unit} of ${request.foodCategory.displayName} has been approved by the admin.',
        type: NotificationType.ngoRequestApproved,
        relatedEntityId: request.id,
        relatedEntityType: 'ngo_request',
      );
    } catch (e) {
      // Ignore notification errors
    }
  }

  Future<void> _notifyAdminsAboutApproval(
    NGORequest request,
    String approvingAdminId,
  ) async {
    if (_authRepository == null || _notificationRepository == null) return;

    try {
      final admins = await _authRepository.getUsersByRole(UserRole.admin);
      final approvingAdmin = await _authRepository.getUserProfile(
        approvingAdminId,
      );

      for (final admin in admins) {
        if (admin.id == approvingAdminId) continue; // Skip the approving admin

        await _notificationRepository.createNotification(
          userId: admin.id,
          title: 'Request Approved',
          body:
              '${approvingAdmin?.fullName ?? "Admin"} approved ${request.ngoName}\'s request for ${request.foodCategory.displayName}',
          type: NotificationType.ngoRequestApproved,
          relatedEntityId: request.id,
          relatedEntityType: 'ngo_request',
          actorName: approvingAdmin?.fullName,
        );
      }
    } catch (e) {
      // Ignore notification errors
    }
  }

  Future<void> _notifyNGOAboutDenial(NGORequest request) async {
    if (_notificationRepository == null) return;

    try {
      await _notificationRepository.createNotification(
        userId: request.ngoId,
        title: 'Request Denied',
        body:
            'Your request for ${request.quantity} ${request.unit} of ${request.foodCategory.displayName} has been denied. Reason: ${request.denialReason ?? "Not specified"}',
        type: NotificationType.ngoRequestDenied,
        relatedEntityId: request.id,
        relatedEntityType: 'ngo_request',
      );
    } catch (e) {
      // Ignore notification errors
    }
  }

  Future<void> _notifyAdminsAboutDenial(
    NGORequest request,
    String denyingAdminId,
  ) async {
    if (_authRepository == null || _notificationRepository == null) return;

    try {
      final admins = await _authRepository.getUsersByRole(UserRole.admin);
      final denyingAdmin = await _authRepository.getUserProfile(denyingAdminId);

      for (final admin in admins) {
        if (admin.id == denyingAdminId) continue; // Skip the denying admin

        await _notificationRepository.createNotification(
          userId: admin.id,
          title: 'Request Denied',
          body:
              '${denyingAdmin?.fullName ?? "Admin"} denied ${request.ngoName}\'s request for ${request.foodCategory.displayName}',
          type: NotificationType.ngoRequestDenied,
          relatedEntityId: request.id,
          relatedEntityType: 'ngo_request',
          actorName: denyingAdmin?.fullName,
        );
      }
    } catch (e) {
      // Ignore notification errors
    }
  }

  Future<void> _notifyVolunteerAboutRecipient(NGORequest request) async {
    if (_notificationRepository == null || request.donationId == null) return;

    try {
      // Get the donation to find the assigned volunteer
      final donationResponse = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'donations',
        rowId: request.donationId!,
      );

      final volunteerId = donationResponse.data['assigned_volunteer_id'];
      if (volunteerId == null) {
        return;
      }

      await _notificationRepository.createNotification(
        userId: volunteerId,
        title: 'Recipient Assigned',
        body:
            'A recipient (${request.ngoName}) has been assigned to your delivery. Please deliver to: ${request.deliveryAddress}',
        type: NotificationType.deliveryAssigned,
        relatedEntityId: request.donationId!,
        relatedEntityType: 'donation',
        actorName: request.ngoName,
      );
    } catch (e) {
      // Ignore notification errors
    }
  }
}
