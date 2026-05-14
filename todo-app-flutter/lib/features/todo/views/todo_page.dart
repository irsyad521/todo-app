import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/animated_background.dart';
import '../../../shared/widgets/pagination_controls.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../user/views/user_page.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import '../widgets/todo_header.dart';
import '../widgets/todo_list.dart';
import '../widgets/todo_actions.dart';
import '../../../core/utils/ui_feedback.dart';
import 'todo_detail_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final controller = TodoController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_update);
    controller.fetch();
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

  Future<void> logout() async {
    final auth = context.read<AuthController>();
    await auth.logout();
    if (!mounted) return;
    context.go('/login');
  }

  void openDetail(int id) {
    final auth = context.read<AuthController>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TodoDetailPage(
          id: id,
          isAdmin: auth.isAdmin,
        ),
      ),
    );
  }

  void openCreate() {
    TodoActions.openCreate(context, controller);
  }

  void openEdit(Todo todo) {
    TodoActions.openEdit(context, controller, todo);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: auth.isAdmin
                ? DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TodoHeader(
                          username: auth.username,
                          onLogout: logout,
                        ),
                        const SizedBox(height: 10),
                        const TabBar(
                          tabs: [
                            Tab(text: 'Tasks'),
                            Tab(text: 'Users'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              buildTaskView(auth),
                              const UserPage(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      TodoHeader(
                        username: auth.username,
                        onLogout: logout,
                      ),
                      Expanded(child: buildTaskView(auth)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildTaskView(AuthController auth) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: openCreate,
          child: const Text('Add Todo'),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TodoList(
            todos: controller.todos,
            isAdmin: auth.isAdmin,
            controller: controller,
            onToggle: (t) async {
              final res = await controller.toggle(t);
              if (!res.isSuccess) {
                UIFeedback.error(context, res.error!);
              }
            },
            onEdit: openEdit,
            onDetail: openDetail,
            loading: controller.loading,
            error: controller.error,
          ),
        ),
        PaginationControls(
          page: controller.page,
          totalPages: controller.totalPages,
          onPrev: controller.prev,
          onNext: controller.next,
        ),
      ],
    );
  }
}