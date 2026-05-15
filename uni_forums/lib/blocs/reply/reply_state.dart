import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';

sealed class ReplyState {}

class ReplyStateInitial extends ReplyState {}

class ReplyStateLoading extends ReplyState {}

class ReplyStateSuccess extends ReplyState {
  final List<ReplyModel> replies;
  ReplyStateSuccess({required this.replies});
}

class ReplyStateFailure extends ReplyState {
  final String error;
  ReplyStateFailure({required this.error});
}
