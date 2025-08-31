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

  // Use Cases
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

  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      getAuthStateChangesUseCase: getIt<GetAuthStateChangesUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );
}
