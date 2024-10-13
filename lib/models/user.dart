class User {
  final String id;
  final String name; // Novo campo
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'], // Mapeamento do nome
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name, // Inclusão do nome
      'email': email,
    };
  }
}
