import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../core/enums/enums.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final UserRole role;
  final String? avatarUrl;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isVerified;
  final bool isActive;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    this.avatarUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.isVerified = false,
    this.isActive = true,
    this.preferences = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['\$id'] ?? json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      role: UserRoleExtension.fromString(json['role'] as String? ?? 'donor'),
      avatarUrl: json['avatar_url'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      preferences: _parsePreferences(json['preferences']),
      createdAt: json['\$createdAt'] != null
          ? DateTime.parse(json['\$createdAt'] as String)
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.now()),
      updatedAt: json['\$updatedAt'] != null
          ? DateTime.parse(json['\$updatedAt'] as String)
          : (json['updated_at'] != null
                ? DateTime.parse(json['updated_at'] as String)
                : DateTime.now()),
    );
  }

  /// Parse preferences from either String (JSON) or Map
  static Map<String, dynamic> _parsePreferences(dynamic preferences) {
    if (preferences == null) return {};
    if (preferences is Map<String, dynamic>) return preferences;
    if (preferences is String) {
      if (preferences.isEmpty || preferences == '{}') return {};
      try {
        final decoded = json.decode(preferences);
        return decoded is Map<String, dynamic> ? decoded : {};
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role.dbValue,
      'avatar_url': avatarUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'is_verified': isVerified,
      'is_active': isActive,
      'preferences': preferences,
    };
  }

  /// Convert to JSON for update operations (excludes id, email, and system fields)
  /// Only includes fields that can be updated by the user
  Map<String, dynamic> toUpdateJson() {
    final data = <String, dynamic>{'full_name': fullName};

    // Only include optional fields if they have values
    if (phone != null && phone!.isNotEmpty) {
      data['phone'] = phone;
    }
    if (address != null && address!.isNotEmpty) {
      data['address'] = address;
    }
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      data['avatar_url'] = avatarUrl;
    }
    if (latitude != null) {
      data['latitude'] = latitude;
    }
    if (longitude != null) {
      data['longitude'] = longitude;
    }

    return data;
  }

  /// Convert to JSON for admin update operations (includes all fields except id and email)
  Map<String, dynamic> toAdminUpdateJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'role': role.dbValue,
      'avatar_url': avatarUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'is_verified': isVerified,
      'is_active': isActive,
      if (preferences.isNotEmpty) 'preferences': preferences,
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? phone,
    UserRole? role,
    String? avatarUrl,
    String? address,
    double? latitude,
    double? longitude,
    bool? isVerified,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, email, fullName, role, isVerified];
}
