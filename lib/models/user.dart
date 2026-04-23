class User {
  final String id;
  final String name;
  final String email;
  final String? organizacion; // Organizacion Id o object dependiendo del populate

  User({
    required this.id,
    required this.name,
    required this.email,
    this.organizacion,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      organizacion: json['organizacion'] is Map
          ? json['organizacion']['_id'] // Extraemos el ID si lo popularon
          : json['organizacion']?.toString(), // Lo guardamos directo si es string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'organizacion': organizacion,
    };
  }
}
