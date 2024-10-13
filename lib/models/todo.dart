class Todo {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;

  Todo({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
  });

  // Converter de Map para Todo
  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json['id'] as int?,
        title: json['title'] as String,
        description: json['description'] as String?,
        isCompleted: json['isCompleted'] == 1,
      );

  // Converter de Todo para Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted ? 1 : 0,
      };
}
