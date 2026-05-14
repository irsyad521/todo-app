import 'package:flutter/material.dart';

class TodoHeader extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  const TodoHeader({
    super.key,
    required this.username,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Tasks',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Hi, $username',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: Colors.white),
        )
      ],
    );
  }
}