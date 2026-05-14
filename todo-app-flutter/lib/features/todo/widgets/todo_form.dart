import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initial;

  const TodoForm({
    super.key,
    required this.onSubmit,
    this.initial,
  });

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  late TextEditingController title;
  late TextEditingController description;
  bool completed = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.initial?['title'] ?? '');
    description =
        TextEditingController(text: widget.initial?['description'] ?? '');
    completed = widget.initial?['completed'] ?? false;
  }

  Future<void> submit() async {
    setState(() => loading = true);

    await widget.onSubmit({
      'title': title.text.trim(),
      'description': description.text.trim(),
      'completed': completed,
    });

    if (mounted) setState(() => loading = false);
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle('Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: description,
            style: const TextStyle(color: Colors.white),
            decoration: inputStyle('Description'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: completed,
            onChanged: (v) => setState(() => completed = v),
            title: const Text(
              'Completed',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: loading ? null : submit,
            child: loading
                ? const CircularProgressIndicator()
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }
}