import 'package:flutter/material.dart';
import '../controllers/system_controller.dart';
import '../../../shared/widgets/animated_background.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({super.key});

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  final controller = SystemController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_update);
    controller.fetchMode();
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

  Color getModeColor(String mode) {
    if (mode == 'production') return Colors.redAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.3),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('System Mode'),
        ),
        body: SafeArea(
          child: Center(
            child: controller.loading
                ? const CircularProgressIndicator()
                : controller.error.isNotEmpty
                    ? Text(
                        controller.error,
                        style: const TextStyle(color: Colors.redAccent),
                      )
                    : controller.currentMode != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Current Mode',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: getModeColor(
                                      controller.currentMode!.mode),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  controller.currentMode!.mode.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'No data',
                            style: TextStyle(color: Colors.white54),
                          ),
          ),
        ),
      ),
    );
  }
}