import 'package:safe_device/safe_device.dart';

class DeviceSecurity {
static Future<bool> isDeviceSafe() async {
  final isJailBroken = await SafeDevice.isJailBroken;
  final isRealDevice = await SafeDevice.isRealDevice;
  final isDevMode = await SafeDevice.isDevelopmentModeEnable;

  if (isJailBroken) return false;
  if (!isRealDevice) return false;
  if (isDevMode) return false;

  return true;
}
}