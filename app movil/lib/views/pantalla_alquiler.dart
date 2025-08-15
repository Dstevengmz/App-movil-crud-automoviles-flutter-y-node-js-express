import 'package:flutter/material.dart';
import '../services/alquiler_service.dart';
import '../services/session_manager.dart';

class PantallaAlquiler extends StatefulWidget {
  final String carroId;
  final String marca;
  final String modelo;
  final int anio;
  final double precio;
  final String imagenUrl;

  const PantallaAlquiler({
    super.key,
    required this.carroId,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.imagenUrl,
  });

  @override
  State<PantallaAlquiler> createState() => _PantallaAlquilerState();
}

class _PantallaAlquilerState extends State<PantallaAlquiler> {
  DateTime? fechaInicio;
  DateTime? fechaFin;
  double? precioTotal;
  bool isLoading = false;

  final Color fondo = const Color(0xFF60B5FF);
  final Color primario = const Color(0xFF3A7DFF);
  final Color secundario = const Color(0xFFFFECDE);
  final Color detalle = const Color(0xFFFF9149);
  final Color texto = const Color(0xFF000000);

  void calcularPrecioTotal() {
    if (fechaInicio != null && fechaFin != null) {
      final diferencia = fechaFin!.difference(fechaInicio!).inDays;
      if (diferencia > 0) {
        setState(() {
          precioTotal = widget.precio * diferencia;
        });
      }
    }
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esInicio) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        if (esInicio) {
          fechaInicio = fechaSeleccionada;
          if (fechaFin != null && fechaFin!.isBefore(fechaInicio!)) {
            fechaFin = null;
            precioTotal = null;
          }
        } else {
          if (fechaInicio != null && fechaSeleccionada.isAfter(fechaInicio!)) {
            fechaFin = fechaSeleccionada;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'La fecha de fin debe ser posterior a la de inicio',
                ),
              ),
            );
            return;
          }
        }
      });
      calcularPrecioTotal();
    }
  }

  Future<void> _confirmarAlquiler() async {
    if (!SessionManager.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe iniciar sesión para alquilar un vehículo'),
        ),
      );
      return;
    }

    if (fechaInicio == null || fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar las fechas de inicio y fin'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final resultado = await AlquilerService.crearAlquiler(
      usuarioId: SessionManager.currentUserId!,
      carroId: widget.carroId,
      fechaInicio: fechaInicio!,
      fechaFin: fechaFin!,
      precioTotal: precioTotal!,
    );

    setState(() {
      isLoading = false;
    });

    if (resultado['success']) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('¡Éxito!'),
              content: const Text('El vehículo ha sido alquilado exitosamente'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
      );
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
        title: const Text('Alquilar Vehículo'),
        backgroundColor: primario,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: secundario,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imagenUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.directions_car,
                              size: 100,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.marca} ${widget.modelo}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Año: ${widget.anio}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Precio por día: \$${widget.precio.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: detalle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Selecciona las fechas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => _seleccionarFecha(context, true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: secundario,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        fechaInicio != null
                            ? 'Inicio: ${fechaInicio!.day}/${fechaInicio!.month}/${fechaInicio!.year}'
                            : 'Seleccionar fecha de inicio',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              InkWell(
                onTap:
                    fechaInicio != null
                        ? () => _seleccionarFecha(context, false)
                        : null,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: fechaInicio != null ? secundario : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        fechaFin != null
                            ? 'Fin: ${fechaFin!.day}/${fechaFin!.month}/${fechaFin!.year}'
                            : 'Seleccionar fecha de fin',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              fechaInicio != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (precioTotal != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: detalle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total a pagar:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$${precioTotal!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (fechaInicio != null && fechaFin != null && !isLoading)
                          ? _confirmarAlquiler
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: detalle,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Confirmar Alquiler',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
