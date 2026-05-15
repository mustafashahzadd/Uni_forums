import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';
import 'package:uni_forums/blocs/auth/auth_bloc.dart';
import 'package:uni_forums/blocs/topic/topic_bloc.dart';
import 'package:uni_forums/blocs/topic/topic_event.dart';
import 'package:uni_forums/blocs/topic/topic_state.dart';
import 'package:uni_forums/firebase_options.dart';
import 'package:uni_forums/login_page.dart';
import 'package:uni_forums/replies_page.dart';
import 'package:uni_forums/utility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(repo: FirebaseAuthRepository())..add(AuthCheckEvent()),
      child: MaterialApp(
        title: 'FAST NUCES Forums',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

/// Decides whether to show LoginPage or ForumsHome based on auth state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoading || state is AuthStateInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AuthStateAuthenticated) {
          return BlocProvider(
            create: (_) =>
                TopicBloc(repo: FirebaseTopicRepository())
                  ..add(LoadTopicsEvent()),
            child: ForumsHome(userEmail: state.email),
          );
        }
        // Unauthenticated or failure  show login
        return const LoginPage();
      },
    );
  }
}

class ForumsHome extends StatelessWidget {
  const ForumsHome({super.key, required this.userEmail});
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAST NUCES Forums'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => context.read<AuthBloc>().add(AuthSignOutEvent()),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black87),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepOrange,
                    child: Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(userEmail, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () => context.read<AuthBloc>().add(AuthSignOutEvent()),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.deepOrange,
                      ),
                    ),
                    onPressed: () => _showAddTopicDialog(context),
                    child: const Text(
                      'Start new topic',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Topics',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ),
          Expanded(
            child: BlocBuilder<TopicBloc, TopicState>(
              builder: (context, state) {
                if (state is TopicStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TopicStateFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                if (state is TopicStateSuccess) {
                  final topics = state.topics;
                  if (topics.isEmpty) {
                    return const Center(
                      child: Text('No topics yet. Start one!'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemCount: topics.length,
                        itemBuilder: (context, index) {
                          final topic = topics[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: topic.isNew
                                ? const CircleAvatar(
                                    radius: 6,
                                    backgroundColor: Colors.deepOrange,
                                  )
                                : Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.deepOrange.shade100,
                                  ),
                            title: Text(
                              topic.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'By ${topic.originalPoster}, ${formatDate(topic.creationDate)}\n${topic.replyCount} REPLIES',
                            ),
                            // days-ago on the right
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '👤',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  formatDaysPassed(topic.creationDate),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RepliesPage(
                                  title: 'FAST NUCES Forums',
                                  topicId: topic.id,
                                  topicModel: topic,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    final titleController = TextEditingController();
    final posterController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Start New Topic'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Topic Title'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                controller: posterController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<TopicBloc>().add(
                  AddTopicEvent(
                    title: titleController.text.trim(),
                    originalPoster: posterController.text.trim(),
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
