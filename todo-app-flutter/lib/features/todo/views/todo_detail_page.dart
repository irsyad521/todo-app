import 'package:flutter/material.dart';
import '../../../shared/widgets/animated_background.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';

class TodoDetailPage extends StatefulWidget {
  final int id;
  final bool isAdmin;

  const TodoDetailPage({
    super.key,
    required this.id,
    required this.isAdmin,
  });

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  final controller = TodoController();

  Todo? todo;
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    try {
      final data = await controller.getById(widget.id);
      todo = data;
    } catch (_) {
      error = 'Error';
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : error.isNotEmpty
                  ? Center(
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white54),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            todo!.title,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            todo!.description ?? 'No description',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            todo!.completed ? 'Completed' : 'Pending',
                            style: TextStyle(
                              color: todo!.completed
                                  ? Colors.greenAccent
                                  : Colors.orangeAccent,
                            ),
                          ),
                          if (widget.isAdmin && todo!.username != null)
                            Text(
                              'Owner: ${todo!.username}',
                              style:
                                  const TextStyle(color: Colors.white60),
                            ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}