import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';

// States = what the UI shows at any given moment
// BLoC emits these after processing an Event

sealed class TopicState {}

// Before anything loads
class TopicStateInitial extends TopicState {}

// While fetching from Firestore — show spinner
class TopicStateLoading extends TopicState {}

// Topics fetched successfully — show the list
class TopicStateSuccess extends TopicState {
  final List<TopicModel> topics;

  TopicStateSuccess({required this.topics});
}

// Something went wrong — show error message
class TopicStateFailure extends TopicState {
  final String error;

  TopicStateFailure({required this.error});
}
