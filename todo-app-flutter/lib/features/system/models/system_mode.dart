class SystemMode {
  final String mode;

  SystemMode({required this.mode});

  bool get isDevelopment => mode == 'development';
  bool get isProduction => mode == 'production';

  factory SystemMode.fromJson(Map<String, dynamic> json) {
    return SystemMode(
      mode: json['mode'],
    );
  }
}