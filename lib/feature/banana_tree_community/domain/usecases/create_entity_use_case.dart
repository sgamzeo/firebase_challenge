import 'package:firebase_challenge/core/data/repositories/post/post_repository.dart';

class CreateEntityUseCase<T> {
  final PostRepository<T> repository;

  CreateEntityUseCase(this.repository);

  Future<void> call(T entity) async {
    try {
      await repository.create(entity);
    } catch (e) {
      rethrow;
    }
  }
}
