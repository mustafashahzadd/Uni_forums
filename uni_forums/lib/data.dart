class Topic {
  final String id;
  final String title;
  final String originalPoster;
  final DateTime creationDate;
  final List<Reply> replies;
  final bool isNew;

  Topic({
    this.id = '',
    required this.title,
    required this.originalPoster,
    required this.creationDate,
    required this.replies,
    required this.isNew,
  });
}

class Reply {
  final String id;
  final String content;
  final String replier;
  final String avatarUrl;
  final DateTime replyDate;
  final int likes;

  Reply({
    this.id = '',
    required this.content,
    required this.replier,
    required this.avatarUrl,
    required this.replyDate,
    required this.likes,
  });
}

List<Topic> topics = [
  Topic(
    title: 'Schon is the best place when not in class',
    originalPoster: 'Alice',
    creationDate: DateTime(2026, 1, 1),
    isNew: true,
    replies: [
      Reply(
        content: 'It is a beautiful location with the marvelous architecture always in sight',
        replier: 'Alice',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        replyDate: DateTime(2026, 1, 1),
        likes: 12,
      ),
      Reply(
        content: 'I completely agree!',
        replier: 'Charlie',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        replyDate: DateTime(2026, 2, 1, 10, 30),
        likes: 0,
      ),
      Reply(
        content: 'I prefer the cafe, but Schon is nice too.',
        replier: 'David',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        replyDate: DateTime(2026, 2, 1, 11, 0),
        likes: 5,
      ),
    ],
  ),
  Topic(
    title: 'Teaching Mathematics to CS students is a joke',
    originalPoster: 'Bob',
    creationDate: DateTime(2026, 1, 2),
    isNew: true,
    replies: [
      Reply(
        content: 'Mathematics is important but the way it is taught does not connect with real-world applications.',
        replier: 'Bob',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        replyDate: DateTime(2026, 1, 2),
        likes: 28,
      ),
      Reply(
        content: 'I think it is important but the way it is taught is outdated.',
        replier: 'Alice',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        replyDate: DateTime(2026, 1, 3),
        likes: 0,
      ),
    ],
  ),
  Topic(
    title: 'Upcoming speed programming contest guides and tips',
    originalPoster: 'Charlie',
    creationDate: DateTime(2026, 2, 3),
    isNew: true,
    replies: [
      Reply(
        content: 'Speed programming contests are all about practice and quick thinking.',
        replier: 'Charlie',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        replyDate: DateTime(2026, 2, 3),
        likes: 0,
      ),
      Reply(
        content: 'Practice makes perfect!',
        replier: 'David',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        replyDate: DateTime(2026, 2, 4),
        likes: 45,
      ),
    ],
  ),
  Topic(
    title: 'Acing web programming with an A+ grade',
    originalPoster: 'David',
    creationDate: DateTime(2026, 2, 4),
    isNew: false,
    replies: [
      Reply(
        content: 'Web programming is all about understanding the basics and building projects.',
        replier: 'David',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        replyDate: DateTime(2026, 2, 4),
        likes: 0,
      ),
      Reply(
        content: 'Focus on projects and understanding the basics.',
        replier: 'Eve',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        replyDate: DateTime(2026, 2, 5),
        likes: 67,
      ),
    ],
  ),
  Topic(
    title: 'How to not be a loser',
    originalPoster: 'Eve',
    creationDate: DateTime(2026, 3, 5),
    isNew: true,
    replies: [
      Reply(
        content: 'Being a winner is about staying positive and working hard.',
        replier: 'Eve',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        replyDate: DateTime(2026, 3, 5),
        likes: 0,
      ),
    ],
  ),
  Topic(
    title: 'Shady scenes behind the cafe',
    originalPoster: 'Frank',
    creationDate: DateTime(2026, 4, 6),
    isNew: false,
    replies: [
      Reply(
        content: 'There are some strange things happening behind the cafe that need attention.',
        replier: 'Frank',
        avatarUrl: 'https://i.pravatar.cc/150?img=6',
        replyDate: DateTime(2026, 4, 6),
        likes: 33,
      ),
      Reply(
        content: 'I have seen some strange things there too.',
        replier: 'Alice',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        replyDate: DateTime(2026, 4, 7),
        likes: 0,
      ),
    ],
  ),
];
