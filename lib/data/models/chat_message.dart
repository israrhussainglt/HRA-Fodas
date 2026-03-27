import 'package:equatable/equatable.dart';

enum MessageType { text, image, location, system }

class ChatMessage extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.type = MessageType.text,
    this.metadata,
    this.isRead = false,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      type: _parseType(json['type'] as String?),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static MessageType _parseType(String? value) {
    switch (value) {
      case 'image':
        return MessageType.image;
      case 'location':
        return MessageType.location;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'type': type.name,
      'metadata': metadata,
      'is_read': isRead,
    };
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        type,
        metadata,
        isRead,
        createdAt,
      ];
}

class Conversation extends Equatable {
  final String id;
  final List<String> participantIds;
  final String? donationId;
  final String? deliveryId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  const Conversation({
    required this.id,
    required this.participantIds,
    this.donationId,
    this.deliveryId,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      participantIds: List<String>.from(json['participant_ids'] as List),
      donationId: json['donation_id'] as String?,
      deliveryId: json['delivery_id'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participant_ids': participantIds,
      'donation_id': donationId,
      'delivery_id': deliveryId,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        participantIds,
        donationId,
        deliveryId,
        lastMessage,
        lastMessageAt,
        createdAt,
      ];
}
