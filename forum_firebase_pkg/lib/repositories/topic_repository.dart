import '../models/topic_model.dart';

/// ABSTRACT class = contract for all Topic DB operations.
/// The main app depends on THIS, not on Firebase directly.
abstract class TopicRepository {
  /// Get all topics as a real-time stream
  Stream<List<TopicModel>> getTopics();

  /// Add a new topic to Firestore
  Future<void> addTopic(TopicModel topic);
}
