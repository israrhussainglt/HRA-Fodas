import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/providers.dart';
import '../../../data/models/chat_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationsScreen extends ConsumerWidget {
  final bool embedded;

  const ConversationsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return embedded
              ? const Center(child: Text('Please login'))
              : const Scaffold(body: Center(child: Text('Please login')));
        }

        final conversationsAsync = ref.watch(conversationsProvider(user.$id));

        final content = conversationsAsync.when(
          data: (conversations) {
            if (conversations.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No conversations yet'),
                    SizedBox(height: 8),
                    Text(
                      'Start a conversation from a donation or delivery',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return _ConversationTile(
                  conversation: conv,
                  currentUserId: user.$id,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );

        if (embedded) {
          return content;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Messages')),
          body: content,
        );
      },
      loading: () => embedded
          ? const Center(child: CircularProgressIndicator())
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => embedded
          ? Center(child: Text('Error: $e'))
          : Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;

  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final otherParticipants = conversation.participantIds
        .where((id) => id != currentUserId)
        .join(', ');

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(otherParticipants.isNotEmpty ? 'Chat' : 'Conversation'),
      subtitle: conversation.lastMessage != null
          ? Text(
              conversation.lastMessage!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : const Text(
              'No messages yet',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
      trailing: conversation.lastMessageAt != null
          ? Text(
              timeago.format(conversation.lastMessageAt!),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      onTap: () => context.push('/chat/${conversation.id}'),
    );
  }
}
