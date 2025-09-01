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
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/post_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/post_remote_data_source_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository_impl.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_comment_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/add_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/get_posts_usecase.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/create_post_usecase.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_comment_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/remove_like_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/upload_image_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<GetStorage>(GetStorage());

  getIt.registerSingleton<TokenManager>(TokenManager(getIt<GetStorage>()));

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

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

  getIt.registerSingleton<AddLikeUseCase>(
    AddLikeUseCase(getIt<PostRepository>()),
  );

  getIt.registerSingleton<RemoveLikeUseCase>(
    RemoveLikeUseCase(getIt<PostRepository>()),
  );

  getIt.registerSingleton<AddCommentUseCase>(
    AddCommentUseCase(getIt<PostRepository>()),
  );

  getIt.registerSingleton<RemoveCommentUseCase>(
    RemoveCommentUseCase(getIt<PostRepository>()),
  );

  getIt.registerSingleton<UploadImageUseCase>(
    UploadImageUseCase(getIt<PostRepository>()),
  );
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
