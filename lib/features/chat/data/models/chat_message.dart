import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.userId,
    required this.nickname,
    required this.createdAt,
  });

  final String id;
  final String text;

  /// Firebase Auth uid (`senderId` in Firestore); legacy docs used `userId`.
  final String userId;
  final String nickname;
  final DateTime createdAt;

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final sender =
        data['senderId'] as String? ?? data['userId'] as String? ?? '';
    return ChatMessage(
      id: doc.id,
      text: data['text'] as String? ?? '',
      userId: sender,
      nickname: data['nickname'] as String? ?? 'Anonym',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
