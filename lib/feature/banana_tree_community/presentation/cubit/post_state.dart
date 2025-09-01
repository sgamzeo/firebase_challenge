import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostEntity> posts;

  const PostLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}

// import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';

// class PostState {
//   final List<PostEntity> posts;
//   final bool isLoading;
//   final String? error;

//   PostState({required this.posts, this.isLoading = false, this.error});

//   PostState copyWith({
//     List<PostEntity>? posts,
//     bool? isLoading,
//     String? error,
//   }) {
//     return PostState(
//       posts: posts ?? this.posts,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }
