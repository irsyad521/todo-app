import 'package:flutter/material.dart';
import '../../../core/utils/ui_feedback.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserActions {
  static Future<void> delete(
    BuildContext context,
    UserController controller,
    int id,
  ) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete User'),
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

    final res = await controller.deleteUser(id);

    if (!context.mounted) return;

    if (res.isSuccess) {
      UIFeedback.success(context, 'Deleted');
    } else {
      UIFeedback.error(context, res.error!);
    }
  }

  static Future<void> toggleRole(
    BuildContext context,
    UserController controller,
    User user,
  ) async {
    final newRole = user.role == 'admin' ? 'user' : 'admin';

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Role'),
        content: Text('Change role to $newRole?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final res = await controller.updateUser(user.id, {
      'role': newRole,
    });

    if (!context.mounted) return;

    if (res.isSuccess) {
      UIFeedback.success(context, 'Role updated');
    } else {
      UIFeedback.error(context, res.error!);
    }
  }
}