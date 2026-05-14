class AuthUser {
  final int id;
  final String username;
  final String role;

  AuthUser({
    required this.id,
    required this.username,
    required this.role,
  });

  bool get isAdmin => role == 'admin';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      username: json['username'],
      role: json['role'],
    );
  }
}