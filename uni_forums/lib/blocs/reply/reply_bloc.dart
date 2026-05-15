import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';
import 'reply_event.dart';
import 'reply_state.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  final ReplyRepository repo;

  ReplyBloc({required this.repo}) : super(ReplyStateInitial()) {
    on<LoadRepliesEvent>(_onLoadReplies);
    on<AddReplyEvent>(_onAddReply);
    on<LikeReplyEvent>(_onLikeReply);
  }

  Future<void> _onLoadReplies(
    LoadRepliesEvent event,
    Emitter<ReplyState> emit,
  ) async {
    emit(ReplyStateLoading());
    try {
      await emit.forEach(
        repo.getReplies(event.topicId),
        onData: (replies) => ReplyStateSuccess(replies: replies),
        onError: (e, _) => ReplyStateFailure(error: e.toString()),
      );
    } catch (e) {
      emit(ReplyStateFailure(error: e.toString()));
    }
  }

  Future<void> _onAddReply(
    AddReplyEvent event,
    Emitter<ReplyState> emit,
  ) async {
    try {
      await repo.addReply(
        event.topicId,
        ReplyModel(
          id: '',
          content: event.content,
          replier: event.replier,
          avatarUrl: 'https://i.pravatar.cc/150?img=1',
          replyDate: DateTime.now(),
          likes: 0,
        ),
      );
    } catch (e) {
      emit(ReplyStateFailure(error: e.toString()));
    }
  }

  Future<void> _onLikeReply(
    LikeReplyEvent event,
    Emitter<ReplyState> emit,
  ) async {
    try {
      await repo.likeReply(event.topicId, event.replyId, event.currentLikes);
    } catch (e) {
      emit(ReplyStateFailure(error: e.toString()));
    }
  }
}
