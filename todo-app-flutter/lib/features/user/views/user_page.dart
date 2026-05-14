import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../widgets/user_header.dart';
import '../widgets/user_list.dart';
import '../widgets/user_edit_dialog.dart';
import '../../../shared/widgets/animated_background.dart';
import '../../../shared/widgets/pagination_controls.dart';
import '../../../core/utils/ui_feedback.dart';
import '../models/user_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controller = UserController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_update);
    controller.fetchUsers();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_update);
    controller.dispose();
    super.dispose();
  }

  void openEdit(User user) {
    showDialog(
      context: context,
      builder: (_) => UserEditDialog(
        user: user,
        onSubmit: (data) async {
          final res = await controller.updateUser(user.id, data);

          if (!mounted) return;

          if (res.isSuccess) {
            UIFeedback.success(context, 'Updated');
          } else {
            UIFeedback.error(context, res.error!);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const UserHeader(),
            if (controller.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (controller.error.isNotEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    controller.error,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              )
            else if (controller.users.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              )
            else
              Expanded(
                child: UserList(
                  users: controller.users,
                  controller: controller,
                  onEdit: openEdit,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PaginationControls(
                page: controller.page,
                totalPages: controller.totalPages,
                onPrev: controller.prevPage,
                onNext: controller.nextPage,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}