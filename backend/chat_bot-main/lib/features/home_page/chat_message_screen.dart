// import 'package:flutter/material.dart';
// import 'package:smart_home/gen/assets.gen.dart';
// import 'package:smart_home/shared/extensions/extensions.dart';
// import 'package:smart_home/shared/widgets/app_text.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<ChatMessage> _messages = [];

//   // Mock data - suggestions từ AI
//   final List<String> _suggestions = [
//     "Remembers what user said earlier in the conversation",
//     "Allows user to provide follow-up corrections dần AI",
//     "Limited knowledge of world and events after 2021",
//     "May occasionally generate incorrect information",
//     "May occasionally produce harmful instructions or biased content",
//   ];

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   void _sendMessage(String text) {
//     if (text.trim().isEmpty) return;

//     setState(() {
//       _messages.add(ChatMessage(
//         text: text,
//         isUser: true,
//         timestamp: DateTime.now(),
//       ));
//     });

//     _messageController.clear();

//     // TODO: Gọi API backend để lấy response
//     // Simulate AI response
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted) {
//         setState(() {
//           _messages.add(ChatMessage(
//             text:
//                 "This is a mock response from AI. Implement your backend API here.",
//             isUser: false,
//             timestamp: DateTime.now(),
//           ));
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 1,
//                 blurRadius: 3,
//               ),
//             ],
//           ),
//           child: IconButton(
//             icon: Assets.icons.leftChevon.svg(),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         title: const AppText(
//           'BrainBox',
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert_rounded),
//             onPressed: () {
//               // Show menu options
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Chat messages hoặc suggestions
//           Expanded(
//             child: _messages.isEmpty
//                 ? _buildSuggestionsView()
//                 : _buildMessagesView(),
//           ),

//           // Input field
//           _buildInputField(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSuggestionsView() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),

//           // Logo hoặc title
//           Assets.images.logo.image(
//             height: 60,
//             color: context.colors.black,
//           ),

//           const SizedBox(height: 20),

//           AppText(
//             'BrainBox',
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: context.colors.black,
//           ),

//           const SizedBox(height: 40),

//           // Suggestion cards
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: _suggestions.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 16),
//             itemBuilder: (context, index) {
//               return _buildSuggestionCard(_suggestions[index]);
//             },
//           ),

//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }

//   Widget _buildSuggestionCard(String text) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         onTap: () {
//           _messageController.text = text;
//           _sendMessage(text);
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: Colors.grey.shade200,
//               width: 1,
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: context.colors.black.withOpacity(0.3),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: AppText(
//                   text,
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessagesView() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: _messages.length,
//       itemBuilder: (context, index) {
//         final message = _messages[index];
//         return _buildMessageBubble(message);
//       },
//     );
//   }

//   Widget _buildMessageBubble(ChatMessage message) {
//     return Align(
//       alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         decoration: BoxDecoration(
//           color: message.isUser ? context.colors.black : Colors.white,
//           borderRadius: BorderRadius.circular(16).copyWith(
//             bottomRight: message.isUser ? const Radius.circular(4) : null,
//             bottomLeft: !message.isUser ? const Radius.circular(4) : null,
//           ),
//           border:
//               !message.isUser ? Border.all(color: Colors.grey.shade200) : null,
//         ),
//         child: AppText(
//           message.text,
//           fontSize: 15,
//           color: message.isUser ? Colors.white : Colors.black87,
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   decoration: InputDecoration(
//                     hintText: 'Send a message...',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade500,
//                       fontSize: 15,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   maxLines: null,
//                   textInputAction: TextInputAction.send,
//                   onSubmitted: _sendMessage,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               decoration: BoxDecoration(
//                 color: context.colors.black,
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 icon: Assets.icons.send.svg(color: context.colors.white),
//                 onPressed: () => _sendMessage(_messageController.text),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Model cho chat message
// class ChatMessage {
//   final String text;
//   final bool isUser;
//   final DateTime timestamp;

//   ChatMessage({
//     required this.text,
//     required this.isUser,
//     required this.timestamp,
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/gen/assets.gen.dart';
import 'package:smart_home/shared/extensions/extensions.dart';
import 'package:smart_home/shared/widgets/app_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // Mock data - suggestions từ AI
  final List<String> _suggestions = [
    "Remembers what user said earlier in the conversation",
    "Allows user to provide follow-up corrections dần AI",
    "Limited knowledge of world and events after 2021",
    "May occasionally generate incorrect information",
    "May occasionally produce harmful instructions or biased content",
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _refreshChat() {
    setState(() {
      _messages.clear();
      _isTyping = false;
    });
  }

  void _showShareOptions(ChatMessage message) {
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
            _buildShareOption(
              icon: Icons.content_copy_rounded,
              label: 'Copy',
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.text));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
            _buildShareOption(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
            _buildShareOption(
              icon: Icons.bookmark_outline_rounded,
              label: 'Bookmark',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement bookmark functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 22),
      ),
      title: AppText(label, fontSize: 16),
      onTap: onTap,
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Show typing indicator
    setState(() => _isTyping = true);

    // TODO: Gọi API backend để lấy response
    // Simulate AI response with delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: "This is a mock response from AI. Implement your backend API here.",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: IconButton(
            icon: Assets.icons.leftChevon.svg(),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const AppText(
          'BrainBox',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _refreshChat,
              tooltip: 'New Chat',
            ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              // Show menu options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages hoặc suggestions
          Expanded(
            child: _messages.isEmpty
                ? _buildSuggestionsView()
                : _buildMessagesView(),
          ),

          // Input field
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildSuggestionsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Logo hoặc title
          Assets.images.logo.image(
            height: 60,
            color: context.colors.black,
          ),

          const SizedBox(height: 20),

          AppText(
            'BrainBox',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: context.colors.black,
          ),

          const SizedBox(height: 40),

          // Suggestion cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildSuggestionCard(_suggestions[index]);
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String text) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          _messageController.text = text;
          _sendMessage(text);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: context.colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  text,
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return _buildTypingIndicator();
        }
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDot(0),
            const SizedBox(width: 4),
            _buildTypingDot(1),
            const SizedBox(width: 4),
            _buildTypingDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final adjustedValue = (value - delay).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, -4 * (1 - (adjustedValue * 2 - 1).abs())),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (_isTyping && mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showShareOptions(message),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: message.isUser ? context.colors.black : Colors.white,
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomRight: message.isUser ? const Radius.circular(4) : null,
              bottomLeft: !message.isUser ? const Radius.circular(4) : null,
            ),
            border: !message.isUser
                ? Border.all(color: Colors.grey.shade200)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                message.text,
                fontSize: 15,
                color: message.isUser ? Colors.white : Colors.black87,
              ),
              if (!message.isUser) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      icon: Icons.content_copy_rounded,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: message.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.share_rounded,
                      onTap: () => _showShareOptions(message),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.refresh_rounded,
                      onTap: () {
                        // TODO: Regenerate response
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Send a message...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: context.colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Assets.icons.send.svg(color: context.colors.white),
                onPressed: () => _sendMessage(_messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model cho chat message
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}