import 'package:flutter/material.dart';

class UserRoleBadge extends StatelessWidget {
  final String role;

  const UserRoleBadge({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin
            ? Colors.purpleAccent.withOpacity(0.15)
            : Colors.blueAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAdmin ? 'ADMIN' : 'USER',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isAdmin ? Colors.purpleAccent : Colors.blueAccent,
        ),
      ),
    );
  }
}