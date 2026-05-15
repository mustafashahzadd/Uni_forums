// Events = user actions or app triggers
// BLoC listens to these and decides what state to emit

sealed class TopicEvent {}

// Fired when screen opens — tells BLoC to fetch topics
class LoadTopicsEvent extends TopicEvent {}

// Fired when user submits "Start new topic" form
class AddTopicEvent extends TopicEvent {
  final String title;
  final String originalPoster;

  AddTopicEvent({required this.title, required this.originalPoster});
}
