import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/animated_background.dart';
import '../../../core/utils/ui_feedback.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleSubmit() async {
    final auth = context.read<AuthController>();

    final res = await auth.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;

    if (res.isSuccess) {
      context.go('/todo');
    } else {
      UIFeedback.error(context, res.error ?? 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Todo App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Column(
                    children: [
                      AppInput(controller: usernameController, label: 'Username'),
                      const SizedBox(height: 14),
                      AppInput(
                        controller: passwordController,
                        label: 'Password',
                        obscure: true,
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'Login',
                        onPressed: handleSubmit,
                        loading: auth.loading,
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: const Text(
                          'Create account',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}