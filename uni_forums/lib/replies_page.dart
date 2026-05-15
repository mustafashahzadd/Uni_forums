import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';
import 'package:uni_forums/blocs/reply/reply_bloc.dart';
import 'package:uni_forums/blocs/reply/reply_event.dart';
import 'package:uni_forums/blocs/reply/reply_state.dart';
import 'package:uni_forums/utility.dart';

class RepliesPage extends StatelessWidget {
  const RepliesPage({
    super.key,
    required this.title,
    required this.topicId,
    required this.topicModel,
  });

  final String title;
  final String topicId;
  final TopicModel topicModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReplyBloc(repo: FirebaseReplyRepository())
            ..add(LoadRepliesEvent(topicId: topicId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<ReplyBloc, ReplyState>(
          builder: (context, state) {
            if (state is ReplyStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReplyStateFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state is ReplyStateSuccess) {
              return _buildBody(context, state.replies);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<ReplyModel> replies) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Topic header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topicModel.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          'By ${topicModel.originalPoster},',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatDate(topicModel.creationDate),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Reply button
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
                      onPressed: () => _showAddReplyDialog(context),
                      child: const Text(
                        'Reply to this topic',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Replies list
            ...replies.map(
              (reply) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: Image.network(
                              reply.avatarUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                        title: Text(
                          reply.replier,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Posted ${formatDate(reply.replyDate)}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          reply.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              label: const Text('Quote'),
                              icon: const Icon(Icons.add),
                            ),
                            const Expanded(child: SizedBox()),
                            // Like button  updates Firestore
                            IconButton(
                              onPressed: () => context.read<ReplyBloc>().add(
                                LikeReplyEvent(
                                  topicId: topicId,
                                  replyId: reply.id,
                                  currentLikes: reply.likes,
                                ),
                              ),
                              icon: Badge(
                                isLabelVisible: true,
                                label: Text(reply.likes.toString()),
                                child: const Icon(Icons.favorite),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAddReplyDialog(BuildContext context) {
    final contentController = TextEditingController();
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Reply'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Your Reply'),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Reply cannot be empty' : null,
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
                context.read<ReplyBloc>().add(
                  AddReplyEvent(
                    topicId: topicId,
                    content: contentController.text.trim(),
                    replier: nameController.text.trim(),
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
