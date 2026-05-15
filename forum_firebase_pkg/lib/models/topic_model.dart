import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a Forum Topic.
/// Mirrors the Firestore document structure.
class TopicModel {
  final String id;
  final String title;
  final String originalPoster;
  final DateTime creationDate;
  final bool isNew;
  final int replyCount;

  TopicModel({
    required this.id,
    required this.title,
    required this.originalPoster,
    required this.creationDate,
    required this.isNew,
    this.replyCount = 0,
  });

  /// FROM Firestore document → TopicModel object
  factory TopicModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TopicModel(
      id: doc.id,
      title: data['title'] ?? '',
      originalPoster: data['originalPoster'] ?? '',
      creationDate: (data['creationDate'] as Timestamp).toDate(),
      isNew: data['isNew'] ?? false,
      replyCount: data['replyCount'] ?? 0,
    );
  }

  /// FROM TopicModel object → Firestore document (Map)
  Map<String, dynamic> toMap() => {
    'title': title,
    'originalPoster': originalPoster,
    'creationDate': Timestamp.fromDate(creationDate),
    'isNew': isNew,
    'replyCount': replyCount,
  };
}
