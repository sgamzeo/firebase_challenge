import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/comment_entity.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_comment_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_comment_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/create_entity_use_case.dart';
import '../../domain/usecases/get_entities_usecase.dart';
import '../../domain/usecases/add_like_use_case.dart';
import '../../domain/usecases/remove_like_use_case.dart';
import '../../domain/usecases/upload_entity_use_case.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetEntitiesUseCase<PostEntity> getPostsUseCase;
  final CreateEntityUseCase<PostEntity> createPostUseCase;
  final AddLikeUseCase addLikeUseCase;
  final RemoveLikeUseCase removeLikeUseCase;
  final AddCommentUseCase addCommentUseCase;
  final RemoveCommentUseCase removeCommentUseCase;
  final UploadEntityUseCase uploadEntityUseCase;

  PostCubit({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.addLikeUseCase,
    required this.removeLikeUseCase,
    required this.addCommentUseCase,
    required this.removeCommentUseCase,
    required this.uploadEntityUseCase,
  }) : super(PostInitial());

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  void pickImage(File image) {
    _selectedImage = image;
    emit(PostImageSelected(image));
  }

  Future<void> fetchPosts() async {
    try {
      emit(PostLoading());

      final posts = await getPostsUseCase();

      // Her post için comments subcollection'ı çek
      final postsWithComments = await Future.wait(
        posts.map((post) async {
          final commentSnapshot = await FirebaseFirestore.instance
              .collection('posts')
              .doc(post.id)
              .collection('comments')
              .get();

          final comments = commentSnapshot.docs
              .map((doc) => CommentEntity.fromMap(doc.data()))
              .toList();

          return post.copyWith(comments: comments);
        }),
      );

      emit(PostLoaded(postsWithComments));
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

      final imageUrl = await uploadEntityUseCase(
        imageFile,
        userId,
        folderName: 'post_images',
      );

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
      _selectedImage = null;
      await fetchPosts();
    } catch (e) {
      emit(PostError('Error creating post: ${e.toString()}'));
    }
  }

  Future<void> toggleLike(PostEntity post, String currentUserId) async {
    try {
      bool isLiked = post.likedBy.contains(currentUserId);
      List<String> updatedLikedBy = List.from(post.likedBy);

      if (isLiked) {
        updatedLikedBy.remove(currentUserId);
        await removeLikeUseCase(post.id, currentUserId);
      } else {
        updatedLikedBy.add(currentUserId);
        await addLikeUseCase(post.id, currentUserId);
      }

      final updatedPost = post.copyWith(likedBy: updatedLikedBy);

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
      final comment = CommentEntity(
        id: const Uuid().v4(),
        userId: userId,
        text: commentText,
        createdAt: DateTime.now(),
        userName: '.',
      );

      // Firestore’a direkt ekleme
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('comments')
          .doc(comment.id)
          .set(comment.toMap());

      // Yorum eklenince postları tekrar fetch et
      await fetchPosts();
    } catch (e) {
      emit(PostError('Error adding comment: $e'));
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
