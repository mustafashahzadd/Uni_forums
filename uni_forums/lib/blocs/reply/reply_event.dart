sealed class ReplyEvent {}

class LoadRepliesEvent extends ReplyEvent {
  final String topicId;
  LoadRepliesEvent({required this.topicId});
}

class AddReplyEvent extends ReplyEvent {
  final String topicId;
  final String content;
  final String replier;

  AddReplyEvent({
    required this.topicId,
    required this.content,
    required this.replier,
  });
}

class LikeReplyEvent extends ReplyEvent {
  final String topicId;
  final String replyId;
  final int currentLikes;

  LikeReplyEvent({
    required this.topicId,
    required this.replyId,
    required this.currentLikes,
  });
}
