import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository_implementation.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/user_repository_implementation.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/forgot_password.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_comment_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/create_entity_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/get_entities_usecase.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_comment_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/upload_entity_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_in.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_up.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_out.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_current_user.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_auth_state.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/user_repository.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';
import 'package:firebase_challenge/feature/auth/cubit/sign_in_cubit.dart';
import 'package:firebase_challenge/feature/auth/cubit/sign_up_cubit.dart';
import 'package:firebase_challenge/feature/chasing_legends/cubit/mascot_cubit.dart';
import 'package:firebase_challenge/core/data/datasources/post/post_remote_data_source_impl.dart';
import 'package:firebase_challenge/core/data/datasources/post/post_remote_data_source.dart';
import 'package:firebase_challenge/core/data/repositories/post/post_repository.dart';
import 'package:firebase_challenge/core/data/datasources/storage/storage_remote_data_source_impl.dart';
import 'package:firebase_challenge/core/data/datasources/storage/storage_remote_data_source.dart';
import 'package:firebase_challenge/core/data/repositories/storage/storage_repository.dart';
import 'package:firebase_challenge/feature/chasing_legends/mascot_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';

// Add new imports
import 'package:firebase_challenge/core/data/datasources/like/like_remote_data_source.dart';
import 'package:firebase_challenge/core/data/datasources/like/like_remote_data_source_impl.dart';
import 'package:firebase_challenge/core/data/repositories/like/like_repository.dart';
import 'package:firebase_challenge/core/data/repositories/like/like_repository_impl.dart';
import 'package:firebase_challenge/core/data/datasources/comment/comment_remote_data_source.dart';
import 'package:firebase_challenge/core/data/datasources/comment/comment_remote_data_source_impl.dart';
import 'package:firebase_challenge/core/data/repositories/comment/comment_repository.dart';
import 'package:firebase_challenge/core/data/repositories/comment/comment_repository_impl.dart';

import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<GetStorage>(GetStorage());
  getIt.registerSingleton<TokenManager>(TokenManager(getIt<GetStorage>()));

  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(FirebaseFirestore.instance),
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
  getIt.registerSingleton<SignOutUseCase>(
    SignOutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetAuthStateChangesUseCase>(
    GetAuthStateChangesUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory(
    () => SendPasswordResetEmailUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(signInUseCase: getIt<SignInUseCase>()),
  );
  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(signUpUseCase: getIt<SignUpUseCase>()),
  );
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      getAuthStateChangesUseCase: getIt<GetAuthStateChangesUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
      sendPasswordResetEmailUseCase: getIt<SendPasswordResetEmailUseCase>(),
    ),
  );

  getIt.registerSingleton<StorageRemoteDataSource>(
    StorageRemoteDataSourceImpl(FirebaseStorage.instance),
  );

  getIt.registerSingleton<StorageRepository>(
    StorageRepository(getIt<StorageRemoteDataSource>()),
  );

  getIt.registerSingleton<UploadEntityUseCase>(
    UploadEntityUseCase(repository: getIt<StorageRepository>()),
  );

  getIt.registerSingleton<PostRemoteDataSource<Mascot>>(
    PostRemoteDataSourceImpl<Mascot>(
      firestore: FirebaseFirestore.instance,
      collectionName: 'mascots',
      fromMap: (map) => Mascot.fromMap(map),
      toMap: (mascot) => mascot.toMap(),
    ),
  );

  getIt.registerSingleton<PostRepository<Mascot>>(
    PostRepository<Mascot>(
      remoteDataSource: getIt<PostRemoteDataSource<Mascot>>(),
    ),
  );

  getIt.registerSingleton<CreateEntityUseCase<Mascot>>(
    CreateEntityUseCase<Mascot>(getIt<PostRepository<Mascot>>()),
  );

  getIt.registerFactory<MascotCubit>(
    () => MascotCubit(
      uploadEntityUseCase: getIt<UploadEntityUseCase>(),
      createEntityUseCase: getIt<CreateEntityUseCase<Mascot>>(),
    ),
  );

  getIt.registerSingleton<LikeRemoteDataSource>(
    LikeRemoteDataSourceImpl(FirebaseFirestore.instance),
  );

  getIt.registerSingleton<LikeRepository>(
    LikeRepositoryImpl(getIt<LikeRemoteDataSource>()),
  );

  getIt.registerSingleton<CommentRemoteDataSource>(
    CommentRemoteDataSourceImpl(FirebaseFirestore.instance),
  );

  getIt.registerSingleton<CommentRepository>(
    CommentRepositoryImpl(getIt<CommentRemoteDataSource>()),
  );

  // 🔹 Like UseCases
  getIt.registerSingleton<AddLikeUseCase>(
    AddLikeUseCase(getIt<LikeRepository>()),
  );
  getIt.registerSingleton<RemoveLikeUseCase>(
    RemoveLikeUseCase(getIt<LikeRepository>()),
  );

  getIt.registerSingleton<AddCommentUseCase>(
    AddCommentUseCase(getIt<CommentRepository>()),
  );
  getIt.registerSingleton<RemoveCommentUseCase>(
    RemoveCommentUseCase(getIt<CommentRepository>()),
  );

  getIt.registerSingleton<PostRemoteDataSource<PostEntity>>(
    PostRemoteDataSourceImpl<PostEntity>(
      firestore: FirebaseFirestore.instance,
      collectionName: 'posts',
      fromMap: (map) => PostEntity.fromMap(map),
      toMap: (post) => post.toMap(),
    ),
  );

  getIt.registerSingleton<PostRepository<PostEntity>>(
    PostRepository<PostEntity>(
      remoteDataSource: getIt<PostRemoteDataSource<PostEntity>>(),
    ),
  );

  getIt.registerSingleton<GetEntitiesUseCase<PostEntity>>(
    GetEntitiesUseCase<PostEntity>(getIt<PostRepository<PostEntity>>()),
  );
  getIt.registerSingleton<CreateEntityUseCase<PostEntity>>(
    CreateEntityUseCase<PostEntity>(getIt<PostRepository<PostEntity>>()),
  );

  getIt.registerFactory<PostCubit>(
    () => PostCubit(
      getPostsUseCase: getIt<GetEntitiesUseCase<PostEntity>>(),
      createPostUseCase: getIt<CreateEntityUseCase<PostEntity>>(),
      addLikeUseCase: getIt<AddLikeUseCase>(),
      removeLikeUseCase: getIt<RemoveLikeUseCase>(),
      addCommentUseCase: getIt<AddCommentUseCase>(),
      removeCommentUseCase: getIt<RemoveCommentUseCase>(),
      uploadEntityUseCase: getIt<UploadEntityUseCase>(),
    ),
  );
}
