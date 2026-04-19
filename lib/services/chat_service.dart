import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/features/chat/data/models/chat_message.dart';

class ChatService {
  ChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _rooms = 'chatRooms';
  static const String _messages = 'messages';

  /// Same id the Laravel API uses for the event/match.
  String getChatId(String eventId) => eventId;

  /// Writes a message document that satisfies Firestore rules (senderId, etc.).
  Future<void> sendMessage({
    required String chatId,
    required String text,
    required String nickname,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('Not signed in; cannot send chat message.');
    }

    try {
      await _firestore
          .collection(_rooms)
          .doc(chatId)
          .collection(_messages)
          .add({
        'senderId': uid,
        'nickname': nickname,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
        'isRemoved': false,
        'removedAt': null,
        'removedReason': null,
      });
      appLog('chat: message written to $_rooms/$chatId/$_messages');
    } catch (e, st) {
      appLog('chat: sendMessage failed: $e\n$st');
      throw Exception('Could not send message: $e');
    }
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection(_rooms)
        .doc(chatId)
        .collection(_messages)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ChatMessage.fromFirestore).toList();
    });
  }

  Future<int> getMessageCount(String chatId) async {
    try {
      final snapshot = await _firestore
          .collection(_rooms)
          .doc(chatId)
          .collection(_messages)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e, st) {
      appLog('chat: getMessageCount failed: $e\n$st');
      return 0;
    }
  }
}
