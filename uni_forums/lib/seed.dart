import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uni_forums/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SeedApp());
}

class SeedApp extends StatefulWidget {
  const SeedApp({super.key});
  @override
  State<SeedApp> createState() => _SeedAppState();
}

class _SeedAppState extends State<SeedApp> {
  String _status = 'Press button to seed Firestore...';

  Future<void> _seed() async {
    setState(() => _status = 'Seeding...');
    try {
      final db = FirebaseFirestore.instance;

      final topics = [
        {
          'title': 'Welcome to FAST NUCES Forums!',
          'originalPoster': 'Admin',
          'creationDate': Timestamp.fromDate(DateTime(2024, 1, 10)),
          'isNew': true,
          'replyCount': 2,
        },
        {
          'title': 'Tips for surviving OOP semester',
          'originalPoster': 'Ali Hassan',
          'creationDate': Timestamp.fromDate(DateTime(2024, 2, 5)),
          'isNew': true,
          'replyCount': 3,
        },
        {
          'title': 'Best resources for Data Structures?',
          'originalPoster': 'Sara Khan',
          'creationDate': Timestamp.fromDate(DateTime(2024, 3, 1)),
          'isNew': false,
          'replyCount': 1,
        },
      ];

      final repliesData = [
        [
          {
            'content': 'Glad to have everyone here! Post your questions freely.',
            'replier': 'Moderator',
            'replyDate': Timestamp.fromDate(DateTime(2024, 1, 11)),
            'avatarUrl': 'https://i.pravatar.cc/150?img=1',
            'likes': 5,
          },
          {
            'content': 'Thanks for creating this forum!',
            'replier': 'Ahmed Raza',
            'replyDate': Timestamp.fromDate(DateTime(2024, 1, 12)),
            'avatarUrl': 'https://i.pravatar.cc/150?img=2',
            'likes': 3,
          },
        ],
        [
          {
            'content': 'Start assignments early, do not wait till the last night!',
            'replier': 'Fatima Noor',
            'replyDate': Timestamp.fromDate(DateTime(2024, 2, 6)),
            'avatarUrl': 'https://i.pravatar.cc/150?img=3',
            'likes': 8,
          },
          {
            'content': 'Attend every lab, the practicals are 40% of the grade.',
            'replier': 'Usman Tariq',
            'replyDate': Timestamp.fromDate(DateTime(2024, 2, 7)),
            'avatarUrl': 'https://i.pravatar.cc/150?img=4',
            'likes': 6,
          },
          {
            'content': 'Use GeeksForGeeks for quick concept revision.',
            'replier': 'Zara Malik',
            'replyDate': Timestamp.fromDate(DateTime(2024, 2, 8)),
            'avatarUrl': 'https://i.pravatar.cc/150?img=5',
            'likes': 4,
          },
        ],
        [
          {
            'content': 'I recommend the CLRS textbook and Abdul Bari on YouTube.',
            'replier': 'Hamza Sheikh',
            'replyDate': Timestamp.fromDate(DateTime(2024, 3, 2)),
            'avatarUrl': 'https://i.pravatar.cc/150?img=6',
            'likes': 10,
          },
        ],
      ];

      for (int i = 0; i < topics.length; i++) {
        final topicRef = await db.collection('topics').add(topics[i]);
        for (final reply in repliesData[i]) {
          await topicRef.collection('replies').add(reply);
        }
      }

      setState(() => _status = ' Done! ${topics.length} topics + replies added to Firestore.');
    } catch (e) {
      setState(() => _status = ' Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Firestore Seeder')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _seed,
                  child: const Text('Seed Firestore Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
