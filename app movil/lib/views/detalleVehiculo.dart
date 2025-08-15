import 'package:flutter/material.dart';
import 'pantalla_alquiler.dart';
import '../services/session_manager.dart';

class DetalleVehiculo extends StatelessWidget {
  final String carroId;
  final String marca;
  final String modelo;
  final int anio;
  final bool disponible;
  final String imagenUrl;
  final double precio;

  const DetalleVehiculo({
    super.key,
    required this.carroId,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.disponible,
    required this.imagenUrl,
    this.precio = 50000,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Vehículo'),
        backgroundColor: Colors.red[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.red[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imagenUrl,
                  height: 120,
                  width: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.directions_car,
                        size: 100,
                        color: Colors.grey,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Marca: $marca',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Modelo: $modelo',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Año: $anio',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Precio por día: \$${precio.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Disponibilidad: '),
                        Text(
                          disponible ? 'Disponible' : 'No Disponible',
                          style: TextStyle(
                            color: disponible ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.car_rental),
                  label: const Text('Alquilar Vehículo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: disponible ? Colors.red[200] : Colors.grey,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed:
                      disponible
                          ? () {
                            if (!SessionManager.isLoggedIn) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Debe iniciar sesión para alquilar un vehículo',
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PantallaAlquiler(
                                      carroId: carroId,
                                      marca: marca,
                                      modelo: modelo,
                                      anio: anio,
                                      precio: precio,
                                      imagenUrl: imagenUrl,
                                    ),
                              ),
                            );
                          }
                          : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
