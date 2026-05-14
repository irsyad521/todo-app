import 'package:flutter/material.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final bool isAdmin;
  final TodoController controller;
  final Function(Todo) onToggle;
  final Function(Todo) onEdit;
  final Function(int) onDetail;
  final bool loading;
  final String error;

  const TodoList({
    super.key,
    required this.todos,
    required this.isAdmin,
    required this.controller,
    required this.onToggle,
    required this.onEdit,
    required this.onDetail,
    required this.loading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Text(
          error,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (todos.isEmpty) {
      return const Center(
        child: Text(
          'No todos',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (_, i) {
        final t = todos[i];
        return TodoItem(
          todo: t,
          isAdmin: isAdmin,
          controller: controller,
          onToggle: onToggle,
          onEdit: onEdit,
          onDetail: onDetail,
        );
      },
    );
  }
}