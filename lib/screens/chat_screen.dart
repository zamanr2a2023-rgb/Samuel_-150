import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../services/chat_service.dart';
import '../l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  final Event event;

  const ChatScreen({Key? key, required this.event}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  String? userId;
  String? nickname;
  String? chatId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  /// Initialiser bruker (hent eller opprett)
  Future<void> _initializeUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Hent eller generer bruker-ID
      String? savedUserId = prefs.getString('userId');
      if (savedUserId == null) {
        savedUserId = _chatService.generateUserId();
        await prefs.setString('userId', savedUserId);
      }

      String? savedNickname = prefs.getString('nickname');
      if (savedNickname == null) {
        savedNickname = await _showUsernameDialog();
        if (savedNickname != null) {
          await prefs.setString('nickname', savedNickname);
        }
      }

      String generatedChatId = _chatService.getChatId(widget.event.id);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        userId = savedUserId;
        nickname = savedNickname ?? l10n.anonymous;
        chatId = generatedChatId;
        isLoading = false;
      });

      print(' Chat initialized: $chatId');
      print(' User: $nickname ($userId)');
    } catch (e) {
      print(' Error initializing user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> _showUsernameDialog() async {
    String? enteredUsername;
    final l10n = AppLocalizations.of(context);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.chooseUsername),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.hintYourName,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              enteredUsername = value;
            },
            onSubmitted: (value) {
              Navigator.of(dialogContext).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );

    final trimmed = enteredUsername?.trim();
    if (trimmed == null || trimmed.isEmpty) return l10n.anonymous;
    return trimmed;
  }

  /// Send melding
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (chatId == null || userId == null) return;

    String messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      await _chatService.sendMessage(
        chatId: chatId!,
        text: messageText,
        userId: userId!,
        nickname: nickname ?? AppLocalizations.of(context).anonymous,
      );

      // Scroll til bunn
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).sendMessageFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Bytt brukernavn
  Future<void> _changeUsername() async {
    String? newNickname = await _showUsernameDialog();
    if (newNickname != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nickname', newNickname);
      setState(() {
        nickname = newNickname;
      });
    }
  }

  String _displayNickname(String raw, AppLocalizations l10n) {
    if (raw.isEmpty) return l10n.anonymous;
    if (raw == 'Anonym' || raw == 'Anonymous') return l10n.anonymous;
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C42),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.isMatch
                  ? '${widget.event.homeTeamText} vs ${widget.event.awayTeamText}'
                  : widget.event.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.event.dag} ${l10n.timeAt} ${widget.event.tid}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _changeUsername,
            tooltip: l10n.changeUsernameTooltip,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF8C42)),
            )
          : Column(
              children: [
                // Info banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFF34495E),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.chatAs(nickname ?? l10n.anonymous),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                // Meldinger
                Expanded(
                  child: chatId == null
                      ? Center(
                          child: Text(
                            l10n.chatLoadFailed,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        )
                      : StreamBuilder<List<ChatMessage>>(
                          stream: _chatService.getMessages(chatId!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  l10n.errorWithDetails('${snapshot.error}'),
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFF8C42),
                                ),
                              );
                            }

                            List<ChatMessage> messages = snapshot.data!;

                            if (messages.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.chat_bubble_outline,
                                        size: 60, color: Colors.white38),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.noMessagesYet,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.beFirstToWrite,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                ChatMessage message = messages[index];
                                // FIKSET: Sjekk også nickname hvis userId mangler (gamle meldinger)
                                bool isCurrentUser = message.userId == userId ||
                                    (message.userId.isEmpty &&
                                        message.nickname == nickname);

                                return _buildMessageBubble(
                                    message, isCurrentUser, l10n);
                              },
                            );
                          },
                        ),
                ),

                // Input felt
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF34495E),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: l10n.hintWriteMessage,
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color(0xFF2C3E50),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFFFF8C42),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMessageBubble(
      ChatMessage message, bool isMe, AppLocalizations l10n) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF8C42) : const Color(0xFF34495E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // VIS NICKNAME FOR ALLE (ikke bare andres!)
            Text(
              _displayNickname(message.nickname, l10n),
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFFFF8C42),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
