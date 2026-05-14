import 'package:go_router/go_router.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/views/login_page.dart';
import '../../features/auth/views/register_page.dart';
import '../../features/todo/views/todo_page.dart';
import '../../features/user/views/user_page.dart';
import '../../features/system/views/system_page.dart';

class AppRouter {
  final AuthController auth;

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: auth,
    redirect: (context, state) {
      final path = state.uri.path;

      final isAuth = auth.isAuthenticated;
      final isAdmin = auth.isAdmin;

      final isLogin = path == '/login';
      final isRegister = path == '/register';
      final isUsers = path == '/users';
      final isSystem = path == '/system';

      if (!isAuth && !isLogin && !isRegister) {
        return '/login';
      }

      if (isAuth && (isLogin || isRegister)) {
        return '/todo';
      }

      if ((isUsers || isSystem) && !isAdmin) {
        return '/todo';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/todo', builder: (context, state) => const TodoPage()),
      GoRoute(path: '/users', builder: (context, state) => const UserPage()),
      GoRoute(path: '/system', builder: (context, state) => const SystemPage()),
    ],
  );

  AppRouter(this.auth);
}