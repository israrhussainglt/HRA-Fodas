import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../models/chat_message.dart';
import '../../appwrite_options.dart';

class ChatRepository {
  final TablesDB _databases; // Changed from _databases to _databases
  final Realtime _realtime;

  ChatRepository(this._databases, this._realtime);

  Future<List<Conversation>> getConversations(String userId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.conversationsCollection,
        queries: [
          Query.search('participant_ids', userId),
          Query.orderDesc('last_message_at'),
        ],
      );

      return response.rows
          .map((doc) => Conversation.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Conversation?> getConversationByParticipants(
    List<String> participantIds,
  ) async {
    try {
      // Sort to ensure consistent lookup
      final sortedIds = List<String>.from(participantIds)..sort();

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.conversationsCollection,
        queries: [Query.equal('participant_ids', sortedIds)],
      );

      if (response.rows.isEmpty) return null;
      return Conversation.fromJson({
        ...response.rows.first.data,
        'id': response.rows.first.$id,
      });
    } catch (e) {
      return null;
    }
  }

  Future<Conversation?> getOrCreateConversation({
    required List<String> participantIds,
    String? donationId,
    String? deliveryId,
  }) async {
    try {
      final sortedIds = List<String>.from(participantIds)..sort();

      // Try to find existing conversation
      final existing = await getConversationByParticipants(sortedIds);
      if (existing != null) return existing;

      // Create new conversation
      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.conversationsCollection,
        rowId: ID.unique(),
        data: {
          'participant_ids': sortedIds,
          'donation_id': donationId,
          'delivery_id': deliveryId,
          'last_message_at': DateTime.now().toIso8601String(),
        },
      );

      return Conversation.fromJson({...response.data, 'id': response.$id});
    } catch (e) {
      return null;
    }
  }

  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.chatMessagesCollection,
        queries: [
          Query.equal('conversation_id', conversationId),
          Query.orderDesc('created_at'),
          Query.limit(limit),
          Query.offset(offset),
        ],
      );

      return response.rows.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['id'] = doc.$id;
        // Parse metadata if it's a JSON string
        if (data['metadata'] != null) {
          data['metadata'] = _parseMetadata(data['metadata']);
        }
        return ChatMessage.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<ChatMessage?> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.chatMessagesCollection,
        rowId: ID.unique(),
        data: {
          'conversation_id': conversationId,
          'sender_id': senderId,
          'content': content,
          'type': type.name,
          'metadata': metadata,
          'is_read': false,
        },
      );

      // Update conversation's last message
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.conversationsCollection,
        rowId: conversationId,
        data: {
          'last_message': content,
          'last_message_at': DateTime.now().toIso8601String(),
        },
      );

      final data = Map<String, dynamic>.from(response.data);
      data['id'] = response.$id;
      // Parse metadata if it's a JSON string
      if (data['metadata'] != null) {
        data['metadata'] = _parseMetadata(data['metadata']);
      }
      return ChatMessage.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    try {
      final unreadMessages = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.chatMessagesCollection,
        queries: [
          Query.equal('conversation_id', conversationId),
          Query.notEqual('sender_id', userId),
          Query.equal('is_read', false),
        ],
      );

      for (final doc in unreadMessages.rows) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.chatMessagesCollection,
          rowId: doc.$id,
          data: {'is_read': true},
        );
      }
    } catch (e) {
      // Ignore errors
    }
  }

  Future<int> getUnreadCount(String userId) async {
    try {
      // Get all conversations for user
      final conversations = await getConversations(userId);
      int totalUnread = 0;

      for (final conv in conversations) {
        final response = await _databases.listRows(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.chatMessagesCollection,
          queries: [
            Query.equal('conversation_id', conv.id),
            Query.notEqual('sender_id', userId),
            Query.equal('is_read', false),
          ],
        );

        totalUnread += response.total;
      }

      return totalUnread;
    } catch (e) {
      return 0;
    }
  }

  Stream<List<ChatMessage>> watchMessages(String conversationId) {
    // TODO: Implement Appwrite Realtime subscriptions
    // For now, return empty stream - implement in UI layer
    return Stream.value([]);
  }

  Stream<List<Conversation>> watchConversations(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    // For now, return empty stream - implement in UI layer
    return Stream.value([]);
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      // Delete all messages first
      final messages = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.chatMessagesCollection,
        queries: [Query.equal('conversation_id', conversationId)],
      );

      for (final doc in messages.rows) {
        await _databases.deleteRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.chatMessagesCollection,
          rowId: doc.$id,
        );
      }

      // Then delete conversation
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.conversationsCollection,
        rowId: conversationId,
      );
    } catch (e) {
      // Ignore errors
    }
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
}
