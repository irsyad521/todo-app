import 'package:flutter/material.dart';
import '../../../core/utils/ui_feedback.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'todo_form.dart';

class TodoActions {
  static void openCreate(
    BuildContext context,
    TodoController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: TodoForm(
          onSubmit: (data) async {
            final res = await controller.create(data);

            if (!context.mounted) return;

            if (res.isSuccess) {
              Navigator.pop(context);
              UIFeedback.success(context, 'Created');
            } else {
              UIFeedback.error(context, res.error!);
            }
          },
        ),
      ),
    );
  }

  static void openEdit(
    BuildContext context,
    TodoController controller,
    Todo todo,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: TodoForm(
          initial: {
            'title': todo.title,
            'description': todo.description,
            'completed': todo.completed,
          },
          onSubmit: (data) async {
            final res = await controller.update(todo.id, data);

            if (!context.mounted) return;

            if (res.isSuccess) {
              Navigator.pop(context);
              UIFeedback.success(context, 'Updated');
            } else {
              UIFeedback.error(context, res.error!);
            }
          },
        ),
      ),
    );
  }

  static Future<void> delete(
    BuildContext context,
    TodoController controller,
    int id,
  ) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final res = await controller.delete(id);

    if (!context.mounted) return;

    if (res.isSuccess) {
      UIFeedback.success(context, 'Deleted');
    } else {
      UIFeedback.error(context, res.error!);
    }
  }
}