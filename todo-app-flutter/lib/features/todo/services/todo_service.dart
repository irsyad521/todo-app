import '../../../core/api/api_client.dart';
import '../../../core/api/paginated_response.dart';
import '../models/todo_model.dart';

class TodoService {
  static Future<PaginatedResponse<Todo>> getTodos({
    int page = 1,
    int limit = 10,
  }) async {
    final res = await ApiClient.get('/todos?page=$page&limit=$limit');

    return PaginatedResponse<Todo>.fromJson(
      data: res['data'],
      meta: res['meta'],
      mapper: (e) => Todo.fromJson(e),
    );
  }

  static Future<Todo> getTodoById(int id) async {
    final res = await ApiClient.get('/todos/$id');
    return Todo.fromJson(res['data']);
  }

  static Future<Todo> createTodo(Map<String, dynamic> body) async {
    final res = await ApiClient.post('/todos', body);
    return Todo.fromJson(res['data']);
  }

  static Future<Todo> updateTodo(int id, Map<String, dynamic> body) async {
    final res = await ApiClient.put('/todos/$id', body);
    return Todo.fromJson(res['data']);
  }

  static Future<void> deleteTodo(int id) async {
    await ApiClient.delete('/todos/$id');
  }
}