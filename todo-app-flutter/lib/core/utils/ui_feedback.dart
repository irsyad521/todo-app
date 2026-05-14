import 'package:flutter/material.dart';
import '../../shared/widgets/app_toast.dart';

class UIFeedback {
  static void success(BuildContext context, String message) {
    AppToast.show(
      context,
      message: message,
      type: ToastType.success,
    );
  }

  static void error(BuildContext context, String message) {
    AppToast.show(
      context,
      message: message,
      type: ToastType.error,
    );
  }
}