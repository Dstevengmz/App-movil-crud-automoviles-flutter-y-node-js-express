import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import '../services/apiservicio.dart';
import 'loginScreen.dart';

class PerfilUsuario extends StatelessWidget {
  const PerfilUsuario({super.key});

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar Sesión'),
            content: const Text('¿Está seguro de que desea cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  ApiService.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Cerrar Sesión'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = SessionManager.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.lightBlue[400],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/1.jpg',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            usuario?.name ?? 'Usuario',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            usuario?.email ?? 'email@example.com',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Editar perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[400],
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _cerrarSesion(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (SessionManager.isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('ID de Usuario'),
              subtitle: Text(usuario?.id ?? 'N/A'),
            ),
            const Divider(),
          ],
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text('Teléfono'),
            subtitle: Text('+57 300 123 4567'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Dirección'),
            subtitle: Text('Bogotá, Colombia'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            subtitle: Text(
              'Usuario de la aplicación de alquiler de vehículos.',
            ),
          ),
        ],
      ),
    );
  }
}
