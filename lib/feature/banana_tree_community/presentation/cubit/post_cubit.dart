import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/upload_image_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/add_comment_use_case.dart';
import '../../domain/usecases/remove_comment_use_case.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import 'post_state.dart';
import 'dart:io';

class PostCubit extends Cubit<PostState> {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final AddLikeUseCase addLikeUseCase;
  final RemoveLikeUseCase removeLikeUseCase;
  final AddCommentUseCase addCommentUseCase;
  final RemoveCommentUseCase removeCommentUseCase;
  final UploadImageUseCase uploadImageUseCase;

  PostCubit({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.addLikeUseCase,
    required this.removeLikeUseCase,
    required this.addCommentUseCase,
    required this.removeCommentUseCase,
    required this.uploadImageUseCase,
  }) : super(PostInitial());

  Future<void> fetchPosts() async {
    try {
      emit(PostLoading());
      final posts = await getPostsUseCase();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> createPostWithImage({
    required File imageFile,
    required String caption,
    required String userId,
  }) async {
    try {
      emit(PostLoading());

      // post image to storage
      final imageUrl = await uploadImageUseCase(imageFile, userId);

      // create post entity
      final post = PostEntity(
        id: const Uuid().v4(),
        userId: userId,
        imageUrl: imageUrl,
        caption: caption,
        likedBy: [],
        comments: [],
        createdAt: DateTime.now(),
      );

      await createPostUseCase(post);
      await fetchPosts();
    } catch (e) {
      emit(PostError('Post oluşturulurken hata oluştu: ${e.toString()}'));
    }
  }

  Future<void> addPost(PostEntity post) async {
    try {
      emit(PostLoading());
      await createPostUseCase(post);
      await fetchPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> toggleLike(PostEntity post, String currentUserId) async {
    try {
      bool isLiked = post.likedBy.contains(currentUserId);

      List<String> updatedLikedBy = List<String>.from(post.likedBy);
      if (isLiked) {
        updatedLikedBy.remove(currentUserId);
        await removeLikeUseCase(post.id, currentUserId);
      } else {
        updatedLikedBy.add(currentUserId);
        await addLikeUseCase(post.id, currentUserId);
      }

      PostEntity updatedPost = post.copyWith(likedBy: updatedLikedBy);

      if (state is PostLoaded) {
        final posts = (state as PostLoaded).posts.map((p) {
          return p.id == post.id ? updatedPost : p;
        }).toList();
        emit(PostLoaded(posts));
      }
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> addComment(
    PostEntity post,
    String userId,
    String commentText,
  ) async {
    try {
      await addCommentUseCase(post.id, userId, commentText);
      await fetchPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> removeComment(PostEntity post, String commentId) async {
    try {
      await removeCommentUseCase(post.id, commentId);
      await fetchPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
