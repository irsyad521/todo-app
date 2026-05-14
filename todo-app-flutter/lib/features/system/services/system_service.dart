import '../../../core/api/api_client.dart';
import '../models/system_mode.dart';

class SystemService {
  static Future<SystemMode> getMode() async {
    final res = await ApiClient.get('/system/mode', adminOnly: true);
    return SystemMode.fromJson(res['data']);
  }
}