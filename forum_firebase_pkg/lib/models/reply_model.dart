import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a Reply inside a Topic.
class ReplyModel {
  final String id;
  final String content;
  final String replier;
  final String avatarUrl;
  final DateTime replyDate;
  final int likes;

  ReplyModel({
    required this.id,
    required this.content,
    required this.replier,
    required this.avatarUrl,
    required this.replyDate,
    required this.likes,
  });

  /// FROM Firestore document → ReplyModel object
  factory ReplyModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ReplyModel(
      id: doc.id,
      content: data['content'] ?? '',
      replier: data['replier'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      replyDate: (data['replyDate'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
    );
  }

  /// FROM ReplyModel object → Firestore document (Map)
  Map<String, dynamic> toMap() => {
    'content': content,
    'replier': replier,
    'avatarUrl': avatarUrl,
    'replyDate': Timestamp.fromDate(replyDate),
    'likes': likes,
  };
}
