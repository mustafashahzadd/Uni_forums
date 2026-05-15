import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/topic_model.dart';
import '../repositories/topic_repository.dart';

/// CONCRETE implementation of TopicRepository using Firestore.
class FirebaseTopicRepository implements TopicRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // All topics live in the 'topics' collection in Firestore
  static const String _collection = 'topics';

  @override
  Stream<List<TopicModel>> getTopics() {
    return _db
        .collection(_collection)
        .orderBy('creationDate', descending: true)
        .snapshots() // real-time stream
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TopicModel.fromDoc(doc)).toList(),
        );
  }

  @override
  Future<void> addTopic(TopicModel topic) {
    return _db.collection(_collection).add(topic.toMap());
  }
}
