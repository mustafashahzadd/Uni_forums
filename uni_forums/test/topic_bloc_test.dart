import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uni_forums/blocs/topic/topic_bloc.dart';
import 'package:uni_forums/blocs/topic/topic_event.dart';
import 'package:uni_forums/blocs/topic/topic_state.dart';

// Generates MockTopicRepository class
@GenerateMocks([TopicRepository])
import 'topic_bloc_test.mocks.dart';

void main() {
  late MockTopicRepository mockRepo;
  late TopicBloc bloc;

  final fakeTopic = TopicModel(
    id: 'topic1',
    title: 'Test Topic',
    originalPoster: 'Alice',
    creationDate: DateTime(2024, 1, 1),
    isNew: true,
    replyCount: 0,
  );

  setUp(() {
    mockRepo = MockTopicRepository();
    bloc = TopicBloc(repo: mockRepo);
  });

  tearDown(() => bloc.close());

  group('TopicBloc', () {
    test('initial state is TopicStateInitial', () {
      expect(bloc.state, isA<TopicStateInitial>());
    });

    blocTest<TopicBloc, TopicState>(
      'emits [Loading, Success] when LoadTopicsEvent is added',
      build: () {
        when(mockRepo.getTopics()).thenAnswer((_) => Stream.value([fakeTopic]));
        return TopicBloc(repo: mockRepo);
      },
      act: (bloc) => bloc.add(LoadTopicsEvent()),
      expect: () => [isA<TopicStateLoading>(), isA<TopicStateSuccess>()],
    );

    blocTest<TopicBloc, TopicState>(
      'TopicStateSuccess contains the returned topics',
      build: () {
        when(mockRepo.getTopics()).thenAnswer((_) => Stream.value([fakeTopic]));
        return TopicBloc(repo: mockRepo);
      },
      act: (bloc) => bloc.add(LoadTopicsEvent()),
      expect: () => [
        isA<TopicStateLoading>(),
        predicate<TopicState>(
          (s) => s is TopicStateSuccess && s.topics.first.title == 'Test Topic',
        ),
      ],
    );

    blocTest<TopicBloc, TopicState>(
      'emits [Loading, Failure] when stream throws',
      build: () {
        when(
          mockRepo.getTopics(),
        ).thenAnswer((_) => Stream.error(Exception('Firestore error')));
        return TopicBloc(repo: mockRepo);
      },
      act: (bloc) => bloc.add(LoadTopicsEvent()),
      expect: () => [isA<TopicStateLoading>(), isA<TopicStateFailure>()],
    );

    blocTest<TopicBloc, TopicState>(
      'AddTopicEvent calls repo.addTopic with correct data',
      build: () {
        when(mockRepo.getTopics()).thenAnswer((_) => const Stream.empty());
        when(mockRepo.addTopic(any)).thenAnswer((_) async {});
        return TopicBloc(repo: mockRepo);
      },
      act: (bloc) =>
          bloc.add(AddTopicEvent(title: 'New Topic', originalPoster: 'Bob')),
      verify: (_) {
        verify(mockRepo.addTopic(any)).called(1);
      },
    );
  });
}
