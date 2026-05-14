import 'package:flutter/material.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/utils/result.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

class TodoController extends ChangeNotifier {
  List<Todo> todos = [];

  bool loading = false;
  String error = '';

  int page = 1;
  int totalPages = 1;
  int limit = 10;

  Future<Result<void>> fetch() async {
    loading = true;
    error = '';
    notifyListeners();

    try {
      final PaginatedResponse<Todo> res =
          await TodoService.getTodos(page: page, limit: limit);

      todos = res.data;
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

  Future<void> next() async {
    if (page < totalPages) {
      page++;
      await fetch();
    }
  }

  Future<void> prev() async {
    if (page > 1) {
      page--;
      await fetch();
    }
  }

  Future<Result<void>> create(Map<String, dynamic> body) async {
    try {
      final todo = await TodoService.createTodo(body);
      todos.insert(0, todo);
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> update(int id, Map<String, dynamic> body) async {
    try {
      final updated = await TodoService.updateTodo(id, body);

      todos = todos.map((t) {
        if (t.id == id) return updated;
        return t;
      }).toList();

      notifyListeners();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> toggle(Todo t) async {
    return update(t.id, {
      'completed': !t.completed,
    });
  }

  Future<Result<void>> delete(int id) async {
    try {
      await TodoService.deleteTodo(id);
      todos.removeWhere((t) => t.id == id);
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Todo?> getById(int id) async {
    try {
      return await TodoService.getTodoById(id);
    } catch (_) {
      return null;
    }
  }
}