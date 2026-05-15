import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reply_model.dart';
import '../repositories/reply_repository.dart';

/// CONCRETE implementation of ReplyRepository using Firestore.
/// Replies are stored as a SUB-COLLECTION inside each topic document.
class FirebaseReplyRepository implements ReplyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Path: topics/{topicId}/replies/{replyId}
  CollectionReference<Map<String, dynamic>> _repliesRef(String topicId) =>
      _db.collection('topics').doc(topicId).collection('replies');

  @override
  Stream<List<ReplyModel>> getReplies(String topicId) {
    return _repliesRef(topicId)
        .orderBy('replyDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ReplyModel.fromDoc(doc)).toList(),
        );
  }

  @override
  Future<void> addReply(String topicId, ReplyModel reply) {
    return _repliesRef(topicId).add(reply.toMap());
  }

  @override
  Future<void> likeReply(String topicId, String replyId, int currentLikes) {
    return _repliesRef(
      topicId,
    ).doc(replyId).update({'likes': currentLikes + 1});
  }
}
