class Todo {
  final int id;
  final String title;
  final String? description;
  final bool completed;
  final bool? isOwner;
  final int? userId;
  final String? username;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    this.isOwner,
    this.userId,
    this.username,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'] ?? false,
      isOwner: json['is_owner'],
      userId: json['user']?['id'],
      username: json['user']?['username'],
    );
  }
}