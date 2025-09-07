import 'package:firebase_challenge/core/data/repositories/post/post_repository.dart';

class GetEntitiesUseCase<T> {
  final PostRepository<T> repository;

  GetEntitiesUseCase(this.repository);

  Future<List<T>> call() async {
    try {
      return await repository.getAll();
    } catch (e) {
      rethrow;
    }
  }
}
