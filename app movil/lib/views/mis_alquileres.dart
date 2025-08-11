import 'package:flutter/material.dart';
import '../services/alquiler_service.dart';
import '../services/session_manager.dart';

class MisAlquileres extends StatefulWidget {
  const MisAlquileres({super.key});

  @override
  State<MisAlquileres> createState() => _MisAlquileresState();
}

class _MisAlquileresState extends State<MisAlquileres> {
  final Color fondo = const Color(0xFF60B5FF);
  final Color primario = const Color(0xFF3A7DFF);
  final Color secundario = const Color(0xFFFFECDE);
  final Color detalle = const Color(0xFFFF9149);
  final Color texto = const Color(0xFF000000);

  Future<List<Map<String, dynamic>>> obtenerMisAlquileres() async {
    if (!SessionManager.isLoggedIn) {
      return [];
    }

    try {
      final resultado = await AlquilerService.obtenerAlquileresUsuario(
        SessionManager.currentUserId!,
      );

      if (resultado['success']) {
        return List<Map<String, dynamic>>.from(resultado['data']);
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener alquileres: $e");
      return [];
    }
  }

  Future<void> finalizarAlquiler(String alquilerId) async {
    final resultado = await AlquilerService.finalizarAlquiler(alquilerId);

    if (resultado['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alquiler finalizado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {}); // Recargar la lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text('Mis Alquileres'),
        backgroundColor: primario,
        foregroundColor: Colors.white,
      ),
      body:
          !SessionManager.isLoggedIn
              ? const Center(
                child: Text(
                  'Debe iniciar sesión para ver sus alquileres',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
              : FutureBuilder<List<Map<String, dynamic>>>(
                future: obtenerMisAlquileres(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tienes alquileres registrados',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  } else {
                    final alquileres = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: alquileres.length,
                      itemBuilder: (context, index) {
                        final alquiler = alquileres[index];
                        final carro = alquiler['carro'];
                        final fechaInicio = DateTime.parse(
                          alquiler['fechaInicio'],
                        );
                        final fechaFin = DateTime.parse(alquiler['fechaFin']);
                        final estado = alquiler['estado'];
                        final precioTotal = alquiler['precioTotal'].toDouble();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          color: secundario,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        carro['imagenUrl'] ?? '',
                                        width: 80,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.directions_car,
                                                  size: 60,
                                                  color: Colors.grey,
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${carro['marca']} ${carro['modelo']}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Año: ${carro['anio']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  estado == 'activo'
                                                      ? Colors.green
                                                      : estado == 'finalizado'
                                                      ? Colors.blue
                                                      : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              estado.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Inicio: ${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Fin: ${fechaFin.day}/${fechaFin.month}/${fechaFin.year}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Total: \$${precioTotal.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: detalle,
                                      ),
                                    ),
                                  ],
                                ),
                                if (estado == 'activo') ...[
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          () => showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: const Text(
                                                    'Finalizar Alquiler',
                                                  ),
                                                  content: const Text(
                                                    '¿Está seguro de que desea finalizar este alquiler?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        'Cancelar',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        finalizarAlquiler(
                                                          alquiler['_id'],
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Finalizar',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text(
                                        'Finalizar Alquiler',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
    );
  }
}
