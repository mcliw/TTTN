// import 'package:flutter/material.dart';

// class HistoryChatScreen extends StatelessWidget {
//   const HistoryChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
import 'package:smart_home/gen/assets.gen.dart';
import 'package:smart_home/shared/extensions/extensions.dart';
import 'package:smart_home/shared/widgets/app_text.dart';
import 'package:intl/intl.dart';

// Model cho chat conversation
class ChatConversation {
  final String id;
  final String title;
  final DateTime timestamp;
  final String firstMessage;

  ChatConversation({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.firstMessage,
  });
}

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data - TODO: Replace with real data from storage
  final List<ChatConversation> _allConversations = [
    ChatConversation(
      id: '1',
      title: 'How Much AI Budget A day',
      timestamp: DateTime.now(),
      firstMessage: 'How much AI budget should I allocate per day?',
    ),
    ChatConversation(
      id: '2',
      title: 'Top AI Tools best You can ever',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      firstMessage: 'What are the top AI tools I can use?',
    ),
    ChatConversation(
      id: '3',
      title: 'Generate text GPT i placed curly flowers',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      firstMessage: 'Can you generate text about curly flowers?',
    ),
    ChatConversation(
      id: '4',
      title: 'How Much AI Budget A day',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      firstMessage: 'How much AI budget should I allocate per day?',
    ),
    ChatConversation(
      id: '5',
      title: 'Top AI Tools best Neroia ever',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      firstMessage: 'What are the best AI tools for Neroia?',
    ),
    ChatConversation(
      id: '6',
      title: 'Top AI Tools best Monica ever',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      firstMessage: 'What are Monica\'s favorite AI tools?',
    ),
    ChatConversation(
      id: '7',
      title: 'Tell me about Support i placed curly flowers',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      firstMessage: 'Tell me about support for curly flowers',
    ),
  ];

  List<ChatConversation> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _filteredConversations = _allConversations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterConversations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = _allConversations;
      } else {
        _filteredConversations = _allConversations
            .where((conv) =>
                conv.title.toLowerCase().contains(query.toLowerCase()) ||
                conv.firstMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _deleteConversation(String id) {
    setState(() {
      _allConversations.removeWhere((conv) => conv.id == id);
      _filteredConversations.removeWhere((conv) => conv.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conversation deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteDialog(ChatConversation conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text('Delete chat?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${conversation.title}"?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteConversation(conversation.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text('Clear all history?'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your chat history.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allConversations.clear();
                _filteredConversations.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Map<String, List<ChatConversation>> _groupByDate() {
    final Map<String, List<ChatConversation>> grouped = {
      'Today': [],
      'Yesterday': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var conv in _filteredConversations) {
      final convDate = DateTime(
        conv.timestamp.year,
        conv.timestamp.month,
        conv.timestamp.day,
      );

      if (convDate == today) {
        grouped['Today']!.add(conv);
      } else if (convDate == yesterday) {
        grouped['Yesterday']!.add(conv);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedConversations = _groupByDate();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const AppText(
          'History',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded),
            onPressed: () {
              // Open in new window
            },
            tooltip: 'Open in new',
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: context.colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                _showOptionsMenu();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: Colors.grey.shade500),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                      onChanged: _filterConversations,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conversations list
          Expanded(
            child: _filteredConversations.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      // Today section
                      if (groupedConversations['Today']!.isNotEmpty) ...[
                        _buildSectionHeader('Today'),
                        ...groupedConversations['Today']!.map(
                          (conv) => _buildConversationItem(conv),
                        ),
                      ],

                      // Yesterday section
                      if (groupedConversations['Yesterday']!.isNotEmpty) ...[
                        _buildSectionHeader('Yesterday'),
                        ...groupedConversations['Yesterday']!.map(
                          (conv) => _buildConversationItem(conv),
                        ),
                      ],

                      // Clear history button
                      if (_allConversations.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextButton.icon(
                            onPressed: _clearAllHistory,
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'clear data now ?remain drag Items',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: AppText(
        title,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildConversationItem(ChatConversation conversation) {
    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteConversation(conversation.id);
      },
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            // Navigate to chat screen with this conversation
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) => ChatScreen(conversationId: conversation.id),
            // ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade100),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        conversation.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        _formatTimestamp(conversation.timestamp),
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    _showConversationOptions(conversation);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          AppText(
            'No conversations yet',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          AppText(
            'Start a new chat to see it here',
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM dd, HH:mm').format(timestamp);
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.delete_sweep_rounded,
              label: 'Clear all history',
              onTap: () {
                Navigator.pop(context);
                _clearAllHistory();
              },
              textColor: Colors.red,
            ),
            _buildMenuOption(
              icon: Icons.download_rounded,
              label: 'Export history',
              onTap: () {
                Navigator.pop(context);
                // TODO: Export functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConversationOptions(ChatConversation conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.edit_outlined,
              label: 'Rename',
              onTap: () {
                Navigator.pop(context);
                // TODO: Rename functionality
              },
            ),
            _buildMenuOption(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: () {
                Navigator.pop(context);
                // TODO: Share functionality
              },
            ),
            _buildMenuOption(
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(conversation);
              },
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor ?? context.colors.black).withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 22, color: textColor),
      ),
      title: AppText(label, fontSize: 16, color: textColor),
      onTap: onTap,
    );
  }
}
