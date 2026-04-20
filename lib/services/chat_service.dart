import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/features/chat/data/models/chat_message.dart';

class ChatService {
  ChatService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const String _rooms = 'chatRooms';
  static const String _messages = 'messages';

  /// Matches the PHP/API event id.
  String getChatId(String eventId) => eventId;

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required String nickname,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }

    try {
      await _db.collection(_rooms).doc(chatId).collection(_messages).add({
        'senderId': uid,
        'nickname': nickname,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
        'isRemoved': false,
        'removedAt': null,
        'removedReason': null,
      });
      appLog('chat write $_rooms/$chatId');
    } catch (e, st) {
      appLog('chat send: $e\n$st');
      throw Exception('Could not send message: $e');
    }
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _db
        .collection(_rooms)
        .doc(chatId)
        .collection(_messages)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snap) => snap.docs.map(ChatMessage.fromFirestore).toList());
  }

  Future<int> getMessageCount(String chatId) async {
    try {
      final snap = await _db
          .collection(_rooms)
          .doc(chatId)
          .collection(_messages)
          .count()
          .get();
      return snap.count ?? 0;
    } catch (e, st) {
      appLog('chat count: $e\n$st');
      return 0;
    }
  }
}
