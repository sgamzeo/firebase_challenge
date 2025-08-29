import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/upload_post_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;

  PostCubit({required this.getPostsUseCase, required this.createPostUseCase})
    : super(PostInitial());

  Future<void> fetchPosts() async {
    try {
      emit(PostLoading());
      final posts = await getPostsUseCase();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> addPost(PostEntity post) async {
    try {
      emit(PostLoading());
      await createPostUseCase(post);
      final posts = await getPostsUseCase();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
