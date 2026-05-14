import '../../../core/api/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthService {
  static Future<void> register(String username, String password) async {
    await ApiClient.post('/auth/register', {
      'username': username,
      'password': password,
    });
  }

  static Future<void> login(String username, String password) async {
    final res = await ApiClient.post('/auth/login', {
      'username': username,
      'password': password,
    });

    final token = res['data']['access_token'];
    await TokenStorage.saveToken(token);
  }
}