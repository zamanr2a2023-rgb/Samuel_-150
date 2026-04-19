import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:programmit_app/core/constants/app_colors.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/features/chat/data/models/chat_message.dart';
import 'package:programmit_app/features/events/data/models/event.dart';
import 'package:programmit_app/l10n/app_localizations.dart';
import 'package:programmit_app/services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.event});

  final Event event;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _chatService = ChatService();

  String? userId;
  String? nickname;
  String? chatId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        final cred = await FirebaseAuth.instance.signInAnonymously();
        authUser = cred.user;
      }
      final uid = authUser?.uid;

      var savedNickname = prefs.getString('nickname');
      if (savedNickname == null) {
        savedNickname = await _showUsernameDialog();
        if (savedNickname != null) {
          await prefs.setString('nickname', savedNickname);
        }
      }

      final generatedChatId = _chatService.getChatId(widget.event.id);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        userId = uid;
        nickname = savedNickname ?? l10n.anonymous;
        chatId = generatedChatId;
        isLoading = false;
      });
      appLog('chat: room=$generatedChatId uid=$uid nick=$savedNickname');
    } catch (e, st) {
      appLog('chat: init failed: $e\n$st');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<String?> _showUsernameDialog() async {
    String? enteredUsername;
    final l10n = AppLocalizations.of(context);

    await showDialog<void>(
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
            onChanged: (value) => enteredUsername = value,
            onSubmitted: (_) => Navigator.of(dialogContext).pop(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
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

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (chatId == null || userId == null || userId!.isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      await _chatService.sendMessage(
        chatId: chatId!,
        text: messageText,
        nickname: nickname ?? AppLocalizations.of(context).anonymous,
      );

      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).sendMessageFailed(e.toString()),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _changeUsername() async {
    final newNickname = await _showUsernameDialog();
    if (newNickname != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nickname', newNickname);
      if (mounted) {
        setState(() => nickname = newNickname);
      }
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
      backgroundColor: AppColors.scaffold,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.isMatch
                  ? '${widget.event.homeTeamText} vs ${widget.event.awayTeamText}'
                  : widget.event.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.event.dag} ${l10n.timeAt} ${widget.event.tid}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.88),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: _changeUsername,
            tooltip: l10n.changeUsernameTooltip,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: AppColors.primary.withValues(alpha: 0.95),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.chatAs(nickname ?? l10n.anonymous),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: chatId == null
                      ? Center(
                          child: Text(
                            l10n.chatLoadFailed,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        )
                      : (userId == null || userId!.isEmpty)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  l10n.chatSignInRequired,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
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
                                  color: AppColors.primary,
                                ),
                              );
                            }

                            final messages = snapshot.data!;

                            if (messages.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.chat_bubble_outline,
                                      size: 60,
                                      color: Colors.white38,
                                    ),
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
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                14,
                                8,
                                14,
                                20,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isCurrentUser = message.userId == userId ||
                                    (message.userId.isEmpty &&
                                        message.nickname == nickname);

                                return _MessageBubble(
                                  message: message,
                                  isMe: isCurrentUser,
                                  displayName: _displayNickname(
                                    message.nickname,
                                    l10n,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                Material(
                  elevation: 12,
                  shadowColor: Colors.black54,
                  color: AppColors.surface,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              readOnly: userId == null || userId!.isEmpty,
                              minLines: 1,
                              maxLines: 5,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.35,
                              ),
                              decoration: InputDecoration(
                                hintText: l10n.hintWriteMessage,
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: AppColors.scaffold,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: FilledButton(
                              onPressed: (userId == null || userId!.isEmpty)
                                  ? null
                                  : _sendMessage,
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    AppColors.surfaceElevated,
                                shape: const CircleBorder(),
                                elevation: 2,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.displayName,
  });

  final ChatMessage message;
  final bool isMe;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final maxBubble = w * 0.88;
    final shortContent =
        message.text.runes.length < 36 && displayName.length < 18;
    final minBubble = shortContent ? (isMe ? 196.0 : 168.0) : 72.0;

    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isMe ? 20 : 5),
      bottomRight: Radius.circular(isMe ? 5 : 20),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minBubble.clamp(72, maxBubble),
          maxWidth: maxBubble,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary : AppColors.surfaceElevated,
            borderRadius: bubbleRadius,
            border: isMe
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: TextStyle(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.95)
                      : AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              SelectableText(
                message.text,
                textAlign: isMe ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: TextStyle(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.78)
                      : Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
