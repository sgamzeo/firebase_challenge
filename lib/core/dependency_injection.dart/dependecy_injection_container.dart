import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository_implementation.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/user_repository.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/user_repository_implementation.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_auth_state_use_case.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_current_user.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_in.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_out.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_up.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/comment/comment_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/comment/comment_remote_data_source_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/like/like_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/like/like_remote_data_source_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/post/post_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/post/post_remote_data_source_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/storage/storage_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/storage/storage_remote_data_source_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/comment/comment_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/comment/comment_repository_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/like/like_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/like/like_repository_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post/post_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post/post_repository_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/storage/storage_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/storage/storage_repository_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_comment_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/get_posts_usecase.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/create_post_usecase.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_comment_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/upload_image_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<GetStorage>(GetStorage());
  getIt.registerSingleton<TokenManager>(TokenManager(getIt<GetStorage>()));
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  // Auth
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      tokenManager: getIt<TokenManager>(),
      userRepository: getIt<UserRepository>(),
    ),
  );

  getIt.registerSingleton<SignInUseCase>(
    SignInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<SignUpUseCase>(
    SignUpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetAuthStateChangesUseCase>(
    GetAuthStateChangesUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<SignOutUseCase>(
    SignOutUseCase(getIt<AuthRepository>()),
  );

  // Post
  getIt.registerSingleton<PostRemoteDataSource>(
    PostRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerSingleton<PostRepository>(
    PostRepositoryImpl(getIt<PostRemoteDataSource>()),
  );

  getIt.registerSingleton<GetPostsUseCase>(
    GetPostsUseCase(getIt<PostRepository>()),
  );
  getIt.registerSingleton<CreatePostUseCase>(
    CreatePostUseCase(getIt<PostRepository>()),
  );

  // Like
  getIt.registerSingleton<LikeRemoteDataSource>(
    LikeRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerSingleton<LikeRepository>(
    LikeRepositoryImpl(getIt<LikeRemoteDataSource>()),
  );
  getIt.registerSingleton<AddLikeUseCase>(
    AddLikeUseCase(getIt<LikeRepository>()),
  );
  getIt.registerSingleton<RemoveLikeUseCase>(
    RemoveLikeUseCase(getIt<LikeRepository>()),
  );

  // Comment
  getIt.registerSingleton<CommentRemoteDataSource>(
    CommentRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerSingleton<CommentRepository>(
    CommentRepositoryImpl(getIt<CommentRemoteDataSource>()),
  );
  getIt.registerSingleton<AddCommentUseCase>(
    AddCommentUseCase(getIt<CommentRepository>()),
  );
  getIt.registerSingleton<RemoveCommentUseCase>(
    RemoveCommentUseCase(getIt<CommentRepository>()),
  );

  // Storage
  getIt.registerSingleton<StorageRemoteDataSource>(
    StorageRemoteDataSourceImpl(getIt<FirebaseStorage>()),
  );

  getIt.registerSingleton<StorageRepository>(
    StorageRepositoryImpl(getIt<StorageRemoteDataSource>()),
  );

  getIt.registerSingleton<UploadImageUseCase>(
    UploadImageUseCase(getIt<StorageRepository>()),
  );

  // Cubits
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      getAuthStateChangesUseCase: getIt<GetAuthStateChangesUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );

  getIt.registerSingleton<PostCubit>(
    PostCubit(
      getPostsUseCase: getIt<GetPostsUseCase>(),
      createPostUseCase: getIt<CreatePostUseCase>(),
      addLikeUseCase: getIt<AddLikeUseCase>(),
      removeLikeUseCase: getIt<RemoveLikeUseCase>(),
      addCommentUseCase: getIt<AddCommentUseCase>(),
      removeCommentUseCase: getIt<RemoveCommentUseCase>(),
      uploadImageUseCase: getIt<UploadImageUseCase>(),
    ),
  );
}
