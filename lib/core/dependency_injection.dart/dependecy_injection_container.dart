import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository_implementation.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_in.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_up.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Storage
  getIt.registerSingleton<GetStorage>(GetStorage());

  // Services
  getIt.registerSingleton<TokenManager>(TokenManager(getIt<GetStorage>()));

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(tokenManager: getIt<TokenManager>()),
  );

  // Use Cases
  getIt.registerSingleton<SignInUseCase>(
    SignInUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<SignUpUseCase>(
    SignUpUseCase(getIt<AuthRepository>()),
  );
}
