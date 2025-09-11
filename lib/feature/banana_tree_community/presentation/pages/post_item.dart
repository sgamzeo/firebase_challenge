import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/comment_entity.dart';
import '../cubit/post_cubit.dart';

class PostItem extends StatelessWidget {
  final PostEntity post;
  final String currentUserId; // Logged-in user ID

  const PostItem({super.key, required this.post, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.imageUrl.isNotEmpty)
            Image.network(post.imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.caption),
          ),
          Row(
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
              Text('${post.comments.length}'),
            ],
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
            return Column(
              children: [
                Expanded(
                  child: BlocBuilder<PostCubit, PostState>(
                    builder: (context, state) {
                      if (state is PostLoaded) {
                        final updatedPost = state.posts.firstWhere(
                          (p) => p.id == post.id,
                          orElse: () => post,
                        );

                        if (updatedPost.comments.isEmpty) {
                          return const Center(child: Text("No comments yet."));
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: updatedPost.comments.length,
                          itemBuilder: (context, index) {
                            final comment = updatedPost.comments[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(comment.text),
                              subtitle: Text(comment.userId),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
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
            );
          },
        );
      },
    );
  }

  void _addComment(BuildContext context, String text) {
    context.read<PostCubit>().addComment(post, currentUserId, text);
  }
}
