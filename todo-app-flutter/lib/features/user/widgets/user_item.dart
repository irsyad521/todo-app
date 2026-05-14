import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import 'user_actions.dart';
import 'user_role_badge.dart';

class UserItem extends StatelessWidget {
  final User user;
  final UserController controller;
  final Function(User) onEdit;

  const UserItem({
    super.key,
    required this.user,
    required this.controller,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          UserActions.toggleRole(context, controller, user),
                      child: UserRoleBadge(role: user.role),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '#${user.id}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => onEdit(user),
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
              ),
              IconButton(
                onPressed: () =>
                    UserActions.delete(context, controller, user.id),
                icon: const Icon(Icons.delete, color: Colors.redAccent),
              ),
            ],
          )
        ],
      ),
    );
  }
}