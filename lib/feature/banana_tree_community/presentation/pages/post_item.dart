import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post_entity.dart';

class PostItem extends StatelessWidget {
  final PostEntity post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final currentUserId = 'currentUserId';

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
              Icon(Icons.comment),
              Text('${post.comments.length}'),
            ],
          ),
        ],
      ),
    );
  }
}
