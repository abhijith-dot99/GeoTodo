
// model class for Todo
class Todo {
  final int id;
  final int userId;
  final String title;
  final bool completed;

  // Constructor to initialize the Todo class
  Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  // Factory method to create a Todo object from a JSON map
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
