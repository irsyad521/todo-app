import 'package:flutter/material.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/utils/result.dart';
import '../../../core/security/device_security.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthUser? currentUser;
  bool loading = false;

  bool get isAuthenticated => currentUser != null;
  bool get isAdmin => currentUser?.role == 'admin';
  String get username => currentUser?.username ?? '';

  Future<bool> _ensureDeviceSafe() async {
    final isSafe = await DeviceSecurity.isDeviceSafe();
    return isSafe;
  }

  Future<Result<void>> loadUser() async {
    loading = true;
    notifyListeners();

    try {
      if (!await _ensureDeviceSafe()) {
        currentUser = null;
        return Result.failure('Device is not secure');
      }

      final payload = await TokenStorage.getPayload();

      if (payload != null) {
        currentUser = AuthUser.fromJson(payload);
      }

      return Result.success(null);
    } catch (_) {
      currentUser = null;
      return Result.failure('Failed to load user');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Result<void>> login(String username, String password) async {
    loading = true;
    notifyListeners();

    try {
      if (!await _ensureDeviceSafe()) {
        return Result.failure('Device is not secure');
      }

      await AuthService.login(username, password);

      final payload = await TokenStorage.getPayload();
      if (payload != null) {
        currentUser = AuthUser.fromJson(payload);
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Result<void>> register(String username, String password) async {
    loading = true;
    notifyListeners();

    try {
      if (!await _ensureDeviceSafe()) {
        return Result.failure('Device is not secure');
      }

      await AuthService.register(username, password);

      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
    currentUser = null;
    notifyListeners();
  }
}