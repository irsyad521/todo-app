import '../../../core/api/api_client.dart';
import '../../../core/api/paginated_response.dart';
import '../models/user_model.dart';

class UserService {
  static Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int limit = 10,
  }) async {
    final res = await ApiClient.get('/users?page=$page&limit=$limit');

    return PaginatedResponse<User>.fromJson(
      data: res['data'],
      meta: res['meta'],
      mapper: (e) => User.fromJson(e),
    );
  }

  static Future<User> getUserById(int id) async {
    final res = await ApiClient.get('/users/$id');
    return User.fromJson(res['data']);
  }

  static Future<User> updateUser(int id, Map<String, dynamic> body) async {
    final res = await ApiClient.put('/users/$id', body);
    return User.fromJson(res['data']);
  }

  static Future<void> deleteUser(int id) async {
    await ApiClient.delete('/users/$id');
  }

  static Future<User> toggleRole(User user) async {
    final newRole = user.role == 'admin' ? 'user' : 'admin';

    final res = await ApiClient.put('/users/${user.id}', {
      'role': newRole,
    });

    return User.fromJson(res['data']);
  }
}