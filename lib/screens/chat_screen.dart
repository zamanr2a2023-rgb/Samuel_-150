import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // Hent eller be om brukernavn (nickname)
      String? savedNickname = prefs.getString('nickname');
      if (savedNickname == null) {
        savedNickname = await _showUsernameDialog();
        if (savedNickname != null) {
          await prefs.setString('nickname', savedNickname);
        }
      }

      // Generer chat ID basert på backend event ID
      String generatedChatId = _chatService.getChatId(widget.event.id);

      setState(() {
        userId = savedUserId;
        nickname = savedNickname ?? 'Anonym';
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

  /// Vis dialog for å velge brukernavn
  Future<String?> _showUsernameDialog() async {
    String? enteredUsername;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Velg brukernavn'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Skriv ditt navn...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              enteredUsername = value;
            },
            onSubmitted: (value) {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    return enteredUsername?.trim().isEmpty ?? true ? 'Anonym' : enteredUsername;
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
        nickname: nickname ?? 'Anonym',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kunne ikke sende melding: $e'),
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

  @override
  Widget build(BuildContext context) {
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
              '${widget.event.dag} kl. ${widget.event.tid}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _changeUsername,
            tooltip: 'Bytt brukernavn',
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
                          'Chat som: $nickname',
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
                      ? const Center(
                          child: Text(
                            'Kunne ikke laste chat',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : StreamBuilder<List<ChatMessage>>(
                          stream: _chatService.getMessages(chatId!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Feil: ${snapshot.error}',
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
                              return const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble_outline,
                                        size: 60, color: Colors.white38),
                                    SizedBox(height: 16),
                                    Text(
                                      'Ingen meldinger ennå',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Vær den første til å skrive!',
                                      style: TextStyle(
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
                                    (message.userId == null &&
                                        message.nickname == nickname);
                                bool isMe = isCurrentUser;

                                return _buildMessageBubble(
                                    message, isCurrentUser);
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
                            hintText: 'Skriv en melding...',
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

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
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
              message.nickname,
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
