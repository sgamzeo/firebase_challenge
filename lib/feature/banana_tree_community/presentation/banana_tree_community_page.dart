import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_cubit.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_state.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/pages/post_item.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/pages/upload_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';

class BananaTreeCommunityPage extends StatefulWidget {
  const BananaTreeCommunityPage({super.key});

  @override
  State<BananaTreeCommunityPage> createState() =>
      _BananaTreeCommunityPageState();
}

class _BananaTreeCommunityPageState extends State<BananaTreeCommunityPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    // Kullanıcının ID'sini alıyoruz
    final authState = context.watch<AuthCubit>().state;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id!
        : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Banana Tree Community'),
        centerTitle: true,
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return const Center(child: Text('No posts yet.'));
            }
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostItem(post: post, currentUserId: currentUserId);
              },
            );
          } else if (state is PostError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadPostPage()),
          );
        },
      ),
    );
  }
}
