import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_cubit.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_state.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/pages/post_item.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/pages/upload_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              return const Center(child: Text('Henüz paylaşım yok.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                // 📌 Pull-to-refresh desteği
                await context.read<PostCubit>().fetchPosts();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostItem(post: post);
                },
              ),
            );
          } else if (state is PostError) {
            return Center(child: Text('Hata: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final authState = context.read<AuthCubit>().state;
          if (authState is AuthAuthenticated) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UploadPostPage(user: authState.user),
              ),
            );
            context.read<PostCubit>().fetchPosts();
          }
          context.read<PostCubit>().fetchPosts();
        },
      ),
    );
  }
}
