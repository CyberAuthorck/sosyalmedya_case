import 'package:sosyalmedya_case/core/models/user.dart';
import 'package:sosyalmedya_case/core/network/api_client.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  Future<List<User>> fetchUsers() async {
    final response = await apiClient.get('/users');
    return (response.data as List).map((json) => User.fromJson(json)).toList();
  }

  Future<User> fetchUser(int id) async {
    final response = await apiClient.get('/users/$id');
    return User.fromJson(response.data);
  }
}
