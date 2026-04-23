import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../services/organization_service.dart';
import '../widgets/organization_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OrganizationService _service = OrganizationService();
  List<Organization> _organizations = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  Future<void> _loadOrganizations() async {
    try {
      final orgs = await _service.getOrganizations();
      setState(() {
        _organizations = orgs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Manager'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text('Error: $_errorMessage'));  /// ' cccc '+ u?.name
    }

    if (_organizations.isEmpty) {
      return const Center(child: Text('No hay organizaciones disponibles'));
    }

    return ListView.builder(
      itemCount: _organizations.length,
      itemBuilder: (context, index) {
        return OrganizationTile(organization: _organizations[index]);
      },
    );
  }
}
