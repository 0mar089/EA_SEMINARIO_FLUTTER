import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../screens/organization_detail_screen.dart';

class OrganizationTile extends StatelessWidget {
  final Organization organization;

  const OrganizationTile({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.business, color: Colors.white),
        ),
        title: Text(
          organization.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Usuarios registrados: ${organization.usuarios.length}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrganizationDetailScreen(organization: organization),
            ),
          );
        },
      ),
    );
  }
}
