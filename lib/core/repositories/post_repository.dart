import 'package:sosyalmedya_case/core/models/post.dart';
import 'package:sosyalmedya_case/core/network/api_client.dart';

class PostRepository {
  final ApiClient apiClient;

  PostRepository({required this.apiClient});

  Future<List<Post>> fetchPosts() async {
    final response = await apiClient.get('/posts');
    return (response.data as List).map((json) => Post.fromJson(json)).toList();
  }

  Future<Post> fetchPost(int id) async {
    final response = await apiClient.get('/posts/$id');
    return Post.fromJson(response.data);
  }

  Future<List<Post>> fetchPostsByUser(int userId) async {
    final response = await apiClient.get(
      '/posts',
      queryParameters: {'userId': userId},
    );
    return (response.data as List).map((json) => Post.fromJson(json)).toList();
  }

  Future<Post> createPost(Post post) async {
    final response = await apiClient.post('/posts', data: post.toJson());
    return Post.fromJson(response.data);
  }

  Future<Post> updatePost(Post post) async {
    final response = await apiClient.put(
      '/posts/${post.id}',
      data: post.toJson(),
    );
    return Post.fromJson(response.data);
  }

  Future<void> deletePost(int id) async {
    await apiClient.delete('/posts/$id');
  }
}
