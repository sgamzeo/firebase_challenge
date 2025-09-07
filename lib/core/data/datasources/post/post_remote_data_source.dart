abstract class PostRemoteDataSource<T> {
  Future<List<T>> getAll();
  Future<void> create(T entity);
}
