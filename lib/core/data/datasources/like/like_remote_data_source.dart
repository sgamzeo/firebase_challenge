abstract class LikeRemoteDataSource {
  Future<void> addLike(String postId, String userId);
  Future<void> removeLike(String postId, String userId);
}
