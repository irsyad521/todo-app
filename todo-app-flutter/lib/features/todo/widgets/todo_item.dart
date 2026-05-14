import 'package:flutter/material.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'todo_actions.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final bool isAdmin;
  final TodoController controller;
  final Function(Todo) onToggle;
  final Function(Todo) onEdit;
  final Function(int) onDetail;

  const TodoItem({
    super.key,
    required this.todo,
    required this.isAdmin,
    required this.controller,
    required this.onToggle,
    required this.onEdit,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final completed = todo.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: completed,
            activeColor: Colors.greenAccent,
            onChanged: (_) => onToggle(todo),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onDetail(todo.id),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration:
                          completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isAdmin && todo.username != null)
                    Text(
                      'by ${todo.username}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => onEdit(todo),
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
              ),
              IconButton(
                onPressed: () =>
                    TodoActions.delete(context, controller, todo.id),
                icon: const Icon(Icons.delete, color: Colors.redAccent),
              ),
            ],
          )
        ],
      ),
    );
  }
}