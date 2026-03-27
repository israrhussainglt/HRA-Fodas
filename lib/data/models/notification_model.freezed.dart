// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_entity_id')
  String? get relatedEntityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_entity_type')
  String? get relatedEntityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'actor_name')
  String? get actorName => throw _privateConstructorUsedError; // Name of person who triggered the notification
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError; // Ignore the 'data' field from database - it's a JSON string that we don't need
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get data => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
    NotificationModel value,
    $Res Function(NotificationModel) then,
  ) = _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String title,
    String message,
    NotificationType type,
    @JsonKey(name: 'is_read') bool isRead,
    @JsonKey(name: 'related_entity_id') String? relatedEntityId,
    @JsonKey(name: 'related_entity_type') String? relatedEntityType,
    @JsonKey(name: 'actor_name') String? actorName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? data,
  });
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? isRead = null,
    Object? relatedEntityId = freezed,
    Object? relatedEntityType = freezed,
    Object? actorName = freezed,
    Object? createdAt = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as NotificationType,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            relatedEntityId: freezed == relatedEntityId
                ? _value.relatedEntityId
                : relatedEntityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            relatedEntityType: freezed == relatedEntityType
                ? _value.relatedEntityType
                : relatedEntityType // ignore: cast_nullable_to_non_nullable
                      as String?,
            actorName: freezed == actorName
                ? _value.actorName
                : actorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(
    _$NotificationModelImpl value,
    $Res Function(_$NotificationModelImpl) then,
  ) = __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String title,
    String message,
    NotificationType type,
    @JsonKey(name: 'is_read') bool isRead,
    @JsonKey(name: 'related_entity_id') String? relatedEntityId,
    @JsonKey(name: 'related_entity_type') String? relatedEntityType,
    @JsonKey(name: 'actor_name') String? actorName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? data,
  });
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(
    _$NotificationModelImpl _value,
    $Res Function(_$NotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? isRead = null,
    Object? relatedEntityId = freezed,
    Object? relatedEntityType = freezed,
    Object? actorName = freezed,
    Object? createdAt = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$NotificationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as NotificationType,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        relatedEntityId: freezed == relatedEntityId
            ? _value.relatedEntityId
            : relatedEntityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        relatedEntityType: freezed == relatedEntityType
            ? _value.relatedEntityType
            : relatedEntityType // ignore: cast_nullable_to_non_nullable
                  as String?,
        actorName: freezed == actorName
            ? _value.actorName
            : actorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.title,
    required this.message,
    required this.type,
    @JsonKey(name: 'is_read') this.isRead = false,
    @JsonKey(name: 'related_entity_id') this.relatedEntityId,
    @JsonKey(name: 'related_entity_type') this.relatedEntityType,
    @JsonKey(name: 'actor_name') this.actorName,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.data = null,
  });

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  final String message;
  @override
  final NotificationType type;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'related_entity_id')
  final String? relatedEntityId;
  @override
  @JsonKey(name: 'related_entity_type')
  final String? relatedEntityType;
  @override
  @JsonKey(name: 'actor_name')
  final String? actorName;
  // Name of person who triggered the notification
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  // Ignore the 'data' field from database - it's a JSON string that we don't need
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? data;

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, title: $title, message: $message, type: $type, isRead: $isRead, relatedEntityId: $relatedEntityId, relatedEntityType: $relatedEntityType, actorName: $actorName, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.relatedEntityId, relatedEntityId) ||
                other.relatedEntityId == relatedEntityId) &&
            (identical(other.relatedEntityType, relatedEntityType) ||
                other.relatedEntityType == relatedEntityType) &&
            (identical(other.actorName, actorName) ||
                other.actorName == actorName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    title,
    message,
    type,
    isRead,
    relatedEntityId,
    relatedEntityType,
    actorName,
    createdAt,
    data,
  );

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(this);
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String title,
    required final String message,
    required final NotificationType type,
    @JsonKey(name: 'is_read') final bool isRead,
    @JsonKey(name: 'related_entity_id') final String? relatedEntityId,
    @JsonKey(name: 'related_entity_type') final String? relatedEntityType,
    @JsonKey(name: 'actor_name') final String? actorName,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) final String? data,
  }) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  String get message;
  @override
  NotificationType get type;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'related_entity_id')
  String? get relatedEntityId;
  @override
  @JsonKey(name: 'related_entity_type')
  String? get relatedEntityType;
  @override
  @JsonKey(name: 'actor_name')
  String? get actorName; // Name of person who triggered the notification
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // Ignore the 'data' field from database - it's a JSON string that we don't need
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get data;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationPreferences.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferences {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_donation_alerts')
  bool get newDonationAlerts => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_reminders')
  bool get pickupReminders => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_updates')
  bool get statusUpdates => throw _privateConstructorUsedError;
  @JsonKey(name: 'chat_messages')
  bool get chatMessages => throw _privateConstructorUsedError;
  @JsonKey(name: 'all_notifications_enabled')
  bool get allNotificationsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesCopyWith<NotificationPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesCopyWith<$Res> {
  factory $NotificationPreferencesCopyWith(
    NotificationPreferences value,
    $Res Function(NotificationPreferences) then,
  ) = _$NotificationPreferencesCopyWithImpl<$Res, NotificationPreferences>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'new_donation_alerts') bool newDonationAlerts,
    @JsonKey(name: 'pickup_reminders') bool pickupReminders,
    @JsonKey(name: 'status_updates') bool statusUpdates,
    @JsonKey(name: 'chat_messages') bool chatMessages,
    @JsonKey(name: 'all_notifications_enabled') bool allNotificationsEnabled,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$NotificationPreferencesCopyWithImpl<
  $Res,
  $Val extends NotificationPreferences
>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? newDonationAlerts = null,
    Object? pickupReminders = null,
    Object? statusUpdates = null,
    Object? chatMessages = null,
    Object? allNotificationsEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            newDonationAlerts: null == newDonationAlerts
                ? _value.newDonationAlerts
                : newDonationAlerts // ignore: cast_nullable_to_non_nullable
                      as bool,
            pickupReminders: null == pickupReminders
                ? _value.pickupReminders
                : pickupReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            statusUpdates: null == statusUpdates
                ? _value.statusUpdates
                : statusUpdates // ignore: cast_nullable_to_non_nullable
                      as bool,
            chatMessages: null == chatMessages
                ? _value.chatMessages
                : chatMessages // ignore: cast_nullable_to_non_nullable
                      as bool,
            allNotificationsEnabled: null == allNotificationsEnabled
                ? _value.allNotificationsEnabled
                : allNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesImplCopyWith<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  factory _$$NotificationPreferencesImplCopyWith(
    _$NotificationPreferencesImpl value,
    $Res Function(_$NotificationPreferencesImpl) then,
  ) = __$$NotificationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'new_donation_alerts') bool newDonationAlerts,
    @JsonKey(name: 'pickup_reminders') bool pickupReminders,
    @JsonKey(name: 'status_updates') bool statusUpdates,
    @JsonKey(name: 'chat_messages') bool chatMessages,
    @JsonKey(name: 'all_notifications_enabled') bool allNotificationsEnabled,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$NotificationPreferencesImplCopyWithImpl<$Res>
    extends
        _$NotificationPreferencesCopyWithImpl<
          $Res,
          _$NotificationPreferencesImpl
        >
    implements _$$NotificationPreferencesImplCopyWith<$Res> {
  __$$NotificationPreferencesImplCopyWithImpl(
    _$NotificationPreferencesImpl _value,
    $Res Function(_$NotificationPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? newDonationAlerts = null,
    Object? pickupReminders = null,
    Object? statusUpdates = null,
    Object? chatMessages = null,
    Object? allNotificationsEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$NotificationPreferencesImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        newDonationAlerts: null == newDonationAlerts
            ? _value.newDonationAlerts
            : newDonationAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        pickupReminders: null == pickupReminders
            ? _value.pickupReminders
            : pickupReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        statusUpdates: null == statusUpdates
            ? _value.statusUpdates
            : statusUpdates // ignore: cast_nullable_to_non_nullable
                  as bool,
        chatMessages: null == chatMessages
            ? _value.chatMessages
            : chatMessages // ignore: cast_nullable_to_non_nullable
                  as bool,
        allNotificationsEnabled: null == allNotificationsEnabled
            ? _value.allNotificationsEnabled
            : allNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesImpl implements _NotificationPreferences {
  const _$NotificationPreferencesImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'new_donation_alerts') this.newDonationAlerts = true,
    @JsonKey(name: 'pickup_reminders') this.pickupReminders = true,
    @JsonKey(name: 'status_updates') this.statusUpdates = true,
    @JsonKey(name: 'chat_messages') this.chatMessages = true,
    @JsonKey(name: 'all_notifications_enabled')
    this.allNotificationsEnabled = true,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$NotificationPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPreferencesImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'new_donation_alerts')
  final bool newDonationAlerts;
  @override
  @JsonKey(name: 'pickup_reminders')
  final bool pickupReminders;
  @override
  @JsonKey(name: 'status_updates')
  final bool statusUpdates;
  @override
  @JsonKey(name: 'chat_messages')
  final bool chatMessages;
  @override
  @JsonKey(name: 'all_notifications_enabled')
  final bool allNotificationsEnabled;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NotificationPreferences(id: $id, userId: $userId, newDonationAlerts: $newDonationAlerts, pickupReminders: $pickupReminders, statusUpdates: $statusUpdates, chatMessages: $chatMessages, allNotificationsEnabled: $allNotificationsEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.newDonationAlerts, newDonationAlerts) ||
                other.newDonationAlerts == newDonationAlerts) &&
            (identical(other.pickupReminders, pickupReminders) ||
                other.pickupReminders == pickupReminders) &&
            (identical(other.statusUpdates, statusUpdates) ||
                other.statusUpdates == statusUpdates) &&
            (identical(other.chatMessages, chatMessages) ||
                other.chatMessages == chatMessages) &&
            (identical(
                  other.allNotificationsEnabled,
                  allNotificationsEnabled,
                ) ||
                other.allNotificationsEnabled == allNotificationsEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    newDonationAlerts,
    pickupReminders,
    statusUpdates,
    chatMessages,
    allNotificationsEnabled,
    createdAt,
    updatedAt,
  );

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
  get copyWith =>
      __$$NotificationPreferencesImplCopyWithImpl<
        _$NotificationPreferencesImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesImplToJson(this);
  }
}

abstract class _NotificationPreferences implements NotificationPreferences {
  const factory _NotificationPreferences({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'new_donation_alerts') final bool newDonationAlerts,
    @JsonKey(name: 'pickup_reminders') final bool pickupReminders,
    @JsonKey(name: 'status_updates') final bool statusUpdates,
    @JsonKey(name: 'chat_messages') final bool chatMessages,
    @JsonKey(name: 'all_notifications_enabled')
    final bool allNotificationsEnabled,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$NotificationPreferencesImpl;

  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'new_donation_alerts')
  bool get newDonationAlerts;
  @override
  @JsonKey(name: 'pickup_reminders')
  bool get pickupReminders;
  @override
  @JsonKey(name: 'status_updates')
  bool get statusUpdates;
  @override
  @JsonKey(name: 'chat_messages')
  bool get chatMessages;
  @override
  @JsonKey(name: 'all_notifications_enabled')
  bool get allNotificationsEnabled;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
  get copyWith => throw _privateConstructorUsedError;
}

FCMToken _$FCMTokenFromJson(Map<String, dynamic> json) {
  return _FCMToken.fromJson(json);
}

/// @nodoc
mixin _$FCMToken {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_type')
  String get deviceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_info')
  String? get deviceInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_used_at')
  DateTime get lastUsedAt => throw _privateConstructorUsedError;

  /// Serializes this FCMToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FCMToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FCMTokenCopyWith<FCMToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMTokenCopyWith<$Res> {
  factory $FCMTokenCopyWith(FCMToken value, $Res Function(FCMToken) then) =
      _$FCMTokenCopyWithImpl<$Res, FCMToken>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String token,
    @JsonKey(name: 'device_type') String deviceType,
    @JsonKey(name: 'device_info') String? deviceInfo,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'last_used_at') DateTime lastUsedAt,
  });
}

/// @nodoc
class _$FCMTokenCopyWithImpl<$Res, $Val extends FCMToken>
    implements $FCMTokenCopyWith<$Res> {
  _$FCMTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FCMToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? token = null,
    Object? deviceType = null,
    Object? deviceInfo = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastUsedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceType: null == deviceType
                ? _value.deviceType
                : deviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceInfo: freezed == deviceInfo
                ? _value.deviceInfo
                : deviceInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastUsedAt: null == lastUsedAt
                ? _value.lastUsedAt
                : lastUsedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FCMTokenImplCopyWith<$Res>
    implements $FCMTokenCopyWith<$Res> {
  factory _$$FCMTokenImplCopyWith(
    _$FCMTokenImpl value,
    $Res Function(_$FCMTokenImpl) then,
  ) = __$$FCMTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String token,
    @JsonKey(name: 'device_type') String deviceType,
    @JsonKey(name: 'device_info') String? deviceInfo,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'last_used_at') DateTime lastUsedAt,
  });
}

/// @nodoc
class __$$FCMTokenImplCopyWithImpl<$Res>
    extends _$FCMTokenCopyWithImpl<$Res, _$FCMTokenImpl>
    implements _$$FCMTokenImplCopyWith<$Res> {
  __$$FCMTokenImplCopyWithImpl(
    _$FCMTokenImpl _value,
    $Res Function(_$FCMTokenImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FCMToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? token = null,
    Object? deviceType = null,
    Object? deviceInfo = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastUsedAt = null,
  }) {
    return _then(
      _$FCMTokenImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceType: null == deviceType
            ? _value.deviceType
            : deviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceInfo: freezed == deviceInfo
            ? _value.deviceInfo
            : deviceInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastUsedAt: null == lastUsedAt
            ? _value.lastUsedAt
            : lastUsedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMTokenImpl implements _FCMToken {
  const _$FCMTokenImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.token,
    @JsonKey(name: 'device_type') required this.deviceType,
    @JsonKey(name: 'device_info') this.deviceInfo,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'last_used_at') required this.lastUsedAt,
  });

  factory _$FCMTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMTokenImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String token;
  @override
  @JsonKey(name: 'device_type')
  final String deviceType;
  @override
  @JsonKey(name: 'device_info')
  final String? deviceInfo;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'last_used_at')
  final DateTime lastUsedAt;

  @override
  String toString() {
    return 'FCMToken(id: $id, userId: $userId, token: $token, deviceType: $deviceType, deviceInfo: $deviceInfo, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, lastUsedAt: $lastUsedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMTokenImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    token,
    deviceType,
    deviceInfo,
    isActive,
    createdAt,
    updatedAt,
    lastUsedAt,
  );

  /// Create a copy of FCMToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMTokenImplCopyWith<_$FCMTokenImpl> get copyWith =>
      __$$FCMTokenImplCopyWithImpl<_$FCMTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMTokenImplToJson(this);
  }
}

abstract class _FCMToken implements FCMToken {
  const factory _FCMToken({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String token,
    @JsonKey(name: 'device_type') required final String deviceType,
    @JsonKey(name: 'device_info') final String? deviceInfo,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    @JsonKey(name: 'last_used_at') required final DateTime lastUsedAt,
  }) = _$FCMTokenImpl;

  factory _FCMToken.fromJson(Map<String, dynamic> json) =
      _$FCMTokenImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get token;
  @override
  @JsonKey(name: 'device_type')
  String get deviceType;
  @override
  @JsonKey(name: 'device_info')
  String? get deviceInfo;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'last_used_at')
  DateTime get lastUsedAt;

  /// Create a copy of FCMToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FCMTokenImplCopyWith<_$FCMTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
