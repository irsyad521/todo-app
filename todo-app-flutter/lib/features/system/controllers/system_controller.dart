import 'package:flutter/material.dart';
import '../../../core/utils/result.dart';
import '../models/system_mode.dart';
import '../services/system_service.dart';

class SystemController extends ChangeNotifier {
  SystemMode? currentMode;
  bool loading = false;
  String error = '';

  Future<Result<void>> fetchMode() async {
    loading = true;
    error = '';
    notifyListeners();

    try {
      currentMode = await SystemService.getMode();
      loading = false;
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return Result.failure(error);
    }
  }
}