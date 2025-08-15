import 'package:flutter/material.dart';
import '../services/apiserviciousuarios.dart';

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({super.key});

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiServicioUsuarios.obtenerUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final usuarios = snapshot.data ?? [];
          if (usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios'));
          }
          return ListView.separated(
            itemCount: usuarios.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final u = usuarios[index];
              final nombre = (u['name'] ?? '').toString();
              final email = (u['email'] ?? '').toString();
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                  ),
                ),
                title: Text(nombre.isNotEmpty ? nombre : '(Sin nombre)'),
                subtitle: Text(email.isNotEmpty ? email : '(Sin email)'),
              );
            },
          );
        },
      ),
    );
  }
}
