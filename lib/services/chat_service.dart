import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ChatMessage {
  final String id;
  final String text;
  final String userId;
  final String nickname;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.userId,
    required this.nickname,
    required this.createdAt,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
      nickname: data['nickname'] ?? 'Anonym',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userId': userId,
      'nickname': nickname,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  /// Generer chat ID basert på backend event ID
  String getChatId(String eventId) {
    // Bruk backend ID direkte (20, 21, 22, etc.)
    return eventId;
  }

  /// Send melding til en kamp-chat
  Future<void> sendMessage({
    required String chatId,
    required String text,
    required String userId,
    required String nickname,
  }) async {
    try {
      await _firestore
          .collection('chatRooms') // ENDRET fra 'chats'!
          .doc(chatId)
          .collection('messages')
          .add({
        'text': text,
        'userId': userId,
        'nickname': nickname,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print(' Message sent to chat: $chatId');
    } catch (e) {
      print(' Error sending message: $e');
      throw Exception('Could not send message: $e');
    }
  }

  /// Hent meldinger for en kamp (real-time stream)
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chatRooms') // ENDRET fra 'chats'!
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(100) // Maksimum 100 meldinger
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    });
  }

  /// Generer unik bruker-ID (lagres lokalt)
  String generateUserId() {
    return _uuid.v4();
  }

  /// Tell antall meldinger i en chat (FIKSET!)
  Future<int> getMessageCount(String chatId) async {
    try {
      // FIKSET: Bruk AggregateQuerySnapshot korrekt
      AggregateQuerySnapshot snapshot = await _firestore
          .collection('chatRooms') // ENDRET fra 'chats'!
          .doc(chatId)
          .collection('messages')
          .count()
          .get();

      // FIKSET: Tilgang count via count property
      return snapshot.count ?? 0;
    } catch (e) {
      print(' Error counting messages: $e');
      return 0;
    }
  }
}
