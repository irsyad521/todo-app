import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import 'user_item.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final UserController controller;
  final Function(User) onEdit;

  const UserList({
    super.key,
    required this.users,
    required this.controller,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      itemBuilder: (_, i) {
        return UserItem(
          user: users[i],
          controller: controller,
          onEdit: onEdit,
        );
      },
    );
  }
}