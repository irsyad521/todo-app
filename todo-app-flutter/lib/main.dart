import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_device/safe_device.dart';
import 'package:safe_device/safe_device_config.dart';

import 'core/api/api_client.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SafeDevice.init(
    SafeDeviceConfig(
      mockLocationCheckEnabled: false,
    ),
  );

  ApiClient.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authController = AuthController();
  late final AppRouter appRouter;

  @override
  void initState() {
    super.initState();
    appRouter = AppRouter(authController);
    init();
  }

  Future<void> init() async {
    await authController.loadUser();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(
          value: authController,
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.router,
      ),
    );
  }
}