import 'package:sosyalmedya_case/core/models/comment.dart';
import 'package:sosyalmedya_case/core/network/api_client.dart';

class CommentRepository {
  final ApiClient apiClient;

  CommentRepository({required this.apiClient});

  Future<List<Comment>> fetchCommentsForPost(int postId) async {
    final response = await apiClient.get('/posts/$postId/comments');
    return (response.data as List)
        .map((json) => Comment.fromJson(json))
        .toList();
  }

  Future<Comment> createComment(Comment comment) async {
    final response = await apiClient.post('/comments', data: comment.toJson());
    return Comment.fromJson(response.data);
  }
}
