import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';
import 'topic_event.dart';
import 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final TopicRepository repo;

  TopicBloc({required this.repo}) : super(TopicStateInitial()) {
    on<LoadTopicsEvent>(_onLoadTopics);
    on<AddTopicEvent>(_onAddTopic);
  }

  // Handler for LoadTopicsEvent
  // repo.getTopics() is a STREAM — real-time updates from Firestore
  // We use await for to listen to each new emission
  Future<void> _onLoadTopics(
    LoadTopicsEvent event,
    Emitter<TopicState> emit,
  ) async {
    emit(TopicStateLoading()); // show spinner
    try {
      await emit.forEach(
        repo.getTopics(), // stream from Firestore
        onData: (topics) =>
            TopicStateSuccess(topics: topics), // new data → success
        onError: (e, _) =>
            TopicStateFailure(error: e.toString()), // error → failure
      );
    } catch (e) {
      emit(TopicStateFailure(error: e.toString()));
    }
  }

  // Handler for AddTopicEvent
  Future<void> _onAddTopic(
    AddTopicEvent event,
    Emitter<TopicState> emit,
  ) async {
    try {
      await repo.addTopic(
        TopicModel(
          id: '',
          title: event.title,
          originalPoster: event.originalPoster,
          creationDate: DateTime.now(),
          isNew: true,
        ),
      );
      // No need to emit success — getTopics() stream auto-updates
    } catch (e) {
      emit(TopicStateFailure(error: e.toString()));
    }
  }
}
