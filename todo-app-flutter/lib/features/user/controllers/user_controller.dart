import 'package:flutter/material.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/utils/result.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserController extends ChangeNotifier {
  List<User> users = [];

  int page = 1;
  int totalPages = 1;
  int limit = 10;

  bool loading = false;
  String error = '';

  Future<Result<void>> fetchUsers() async {
    loading = true;
    error = '';
    notifyListeners();

    try {
      final PaginatedResponse<User> res =
          await UserService.getUsers(page: page, limit: limit);

      users = res.data;
      totalPages = res.meta.totalPages;

      loading = false;
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      error = e.toString();

      loading = false;
      notifyListeners();
      return Result.failure(error);
    }
  }

  Future<void> nextPage() async {
    if (page < totalPages) {
      page++;
      await fetchUsers();
    }
  }

  Future<void> prevPage() async {
    if (page > 1) {
      page--;
      await fetchUsers();
    }
  }

  Future<Result<void>> deleteUser(int id) async {
    try {
      await UserService.deleteUser(id);
      await fetchUsers();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> updateUser(int id, Map<String, dynamic> body) async {
    try {
      final payload = <String, dynamic>{};

      if (body.containsKey('role')) {
        payload['role'] = body['role'];
      }

      await UserService.updateUser(id, payload);
      await fetchUsers();

      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> toggleRole(User user) async {
    try {
      await UserService.toggleRole(user);
      await fetchUsers();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}