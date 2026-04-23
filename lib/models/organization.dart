class OrganizationUser {
  final String id;
  final String name;

  OrganizationUser({required this.id, required this.name});

  factory OrganizationUser.fromJson(dynamic rawUser) {
    if (rawUser is Map<String, dynamic>) {
      final String id = (rawUser['_id'] ?? rawUser['id'] ?? '').toString();
      final String name = (rawUser['name'] ?? '').toString();
      return OrganizationUser(id: id, name: name.isEmpty ? id : name);
    }

    // Fallback for older payloads where users can arrive as plain string ids.
    final String value = rawUser.toString();
    return OrganizationUser(id: value, name: value);
  }
}

class Organization {
  final String id;
  final String name;
  final List<OrganizationUser> usuarios;

  Organization({required this.id, required this.name, required this.usuarios});

  // Esto es un constructor que permite crear el json
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Sin nombre',

      usuarios:
          (json['usuarios'] as List<dynamic>?)
              ?.map((dynamic user) => OrganizationUser.fromJson(user))
              .toList() ??
          [],
    );
  }
}
