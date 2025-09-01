import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_state.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/pages/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/post_cubit.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is PostLoaded) {
          final posts = state.posts;

          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostItem(post: posts[index]);
            },
          );
        } else {
          return const Center(child: Text('No posts available'));
        }
      },
    );
  }
}
