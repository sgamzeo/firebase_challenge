import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post_entity.dart';
import '../cubit/post_cubit.dart';
import 'package:uuid/uuid.dart';

class PostItem extends StatelessWidget {
  final PostEntity post;
  final String currentUserId;

  const PostItem({super.key, required this.post, required this.currentUserId});

  Future<String> _getUserName(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if (doc.exists) {
      final data = doc.data();
      return data?['name'] ?? 'Unknown';
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder<String>(
              future: _getUserName(post.userId),
              builder: (context, snapshot) {
                final displayName = snapshot.data ?? 'Unknown';
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade200,
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: post.imageUrl,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(post.caption, style: const TextStyle(fontSize: 14)),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.likedBy.contains(currentUserId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<PostCubit>().toggleLike(post, currentUserId);
                  },
                ),
                Text('${post.likedBy.length}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    _showCommentsBottomSheet(context);
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(post.id)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('0');
                    return Text('${snapshot.data!.docs.length}');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(post.id)
                          .collection('comments')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final comments = snapshot.data!.docs;

                        if (comments.isEmpty) {
                          return const Center(child: Text("No comments yet."));
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final commentData =
                                comments[index].data() as Map<String, dynamic>;

                            final userId = commentData['userId'] ?? '';
                            final text = commentData['text'] ?? '';

                            final timestamp = commentData['createdAt'];
                            final createdAt = (timestamp is Timestamp)
                                ? timestamp.toDate()
                                : DateTime.now();

                            return FutureBuilder<String>(
                              future: _getUserName(userId),
                              builder: (context, snapshot) {
                                final displayName = snapshot.data ?? 'Unknown';
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade200,
                                    child: Text(
                                      displayName.isNotEmpty
                                          ? displayName[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(text),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')} ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Write a comment...",
                              contentPadding: EdgeInsets.all(12),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _addComment(context, value);
                                controller.clear();
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              _addComment(context, controller.text);
                              controller.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addComment(BuildContext context, String text) {
    final authState = context.read<AuthCubit>().state;
    String userId = '';
    if (authState is AuthAuthenticated) {
      userId = authState.user.id ?? '';
    }

    final comment = {
      'id': const Uuid().v4(),
      'userId': userId,
      'text': text,
      'createdAt': Timestamp.fromDate(DateTime.now()),
    };

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('comments')
        .doc(comment['id'] as String)
        .set(comment);
  }
}
