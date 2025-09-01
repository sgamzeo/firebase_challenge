abstract class CommentRepository {
  Future<void> addComment(String postId, String userId, String comment);
  Future<void> removeComment(String postId, String commentId);
}
