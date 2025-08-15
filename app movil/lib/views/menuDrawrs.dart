import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import '../services/apiservicio.dart';
import 'loginScreen.dart';
import 'listaUsuarios.dart';
import 'editarPerfil.dart';

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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        children: [
          const SizedBox(height: 24),
          Center(
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/1.jpg',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              usuario?.name ?? 'Usuario',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Center(
            child: Text(
              usuario?.email ?? 'email@example.com',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('Nombre'),
                  subtitle: Text(usuario?.name ?? 'Usuario'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.alternate_email),
                  title: const Text('Email'),
                  subtitle: Text(usuario?.email ?? 'email@example.com'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final changed = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditarPerfil(),
                        ),
                      );
                      if (changed == true) {
                        (context as Element).markNeedsBuild();
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar perfil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[400],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _cerrarSesion(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (SessionManager.isLoggedIn) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('ID de Usuario'),
                subtitle: Text(usuario?.id ?? 'N/A'),
              ),
            ),
            const Divider(),
          ],
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Usuarios registrados'),
            subtitle: const Text('Ver todos los usuarios'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListaUsuarios()),
              );
            },
          ),
        ],
      ),
    );
  }
}
