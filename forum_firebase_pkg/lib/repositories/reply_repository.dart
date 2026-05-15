import '../models/reply_model.dart';

/// ABSTRACT class = contract for all Reply DB operations.
abstract class ReplyRepository {
  /// Get all replies for a topic as a real-time stream
  Stream<List<ReplyModel>> getReplies(String topicId);

  /// Add a reply to a topic
  Future<void> addReply(String topicId, ReplyModel reply);

  /// Increment like count on a reply
  Future<void> likeReply(String topicId, String replyId, int currentLikes);
}
