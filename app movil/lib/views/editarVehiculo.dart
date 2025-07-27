import 'package:flutter/material.dart';
import '../services/apiservicioeditarcarro.dart';

class EditarVehiculo extends StatefulWidget {
  final String id;
  final String marca;
  final String modelo;
  final int anio;
  final bool disponible;
  final String imagenUrl;

  const EditarVehiculo({
    super.key,
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.disponible,
    required this.imagenUrl,
  });

  @override
  State<EditarVehiculo> createState() => _EditarVehiculoState();
}

class _EditarVehiculoState extends State<EditarVehiculo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _anioController;
  late TextEditingController _imagenUrlController;
  late bool _disponible;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController(text: widget.marca);
    _modeloController = TextEditingController(text: widget.modelo);
    _anioController = TextEditingController(text: widget.anio.toString());
    _imagenUrlController = TextEditingController(text: widget.imagenUrl);
    _disponible = widget.disponible;
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('Intentando guardar cambios...');
        print('ID: ${widget.id}');
        print('Marca: ${_marcaController.text}');
        print('Modelo: ${_modeloController.text}');
        print('Año: ${_anioController.text}');
        print('Disponible: $_disponible');
        print('ImagenUrl: ${_imagenUrlController.text}');

        final resultado = await ApiServiceEditarCarro.editarCarro(
          widget.id,
          _marcaController.text,
          _modeloController.text,
          int.parse(_anioController.text),
          _disponible,
          _imagenUrlController.text,
        );

        print('Resultado del servicio: $resultado');

        if (resultado['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vehículo actualizado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${resultado['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error capturado: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Vehículo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _imagenUrlController.text.isNotEmpty
                      ? _imagenUrlController.text
                      : widget.imagenUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 50,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Imagen no disponible',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _marcaController,
                        decoration: const InputDecoration(
                          labelText: 'Marca',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.directions_car),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la marca';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _modeloController,
                        decoration: const InputDecoration(
                          labelText: 'Modelo',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.car_rental),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el modelo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _anioController,
                        decoration: const InputDecoration(
                          labelText: 'Año',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el año';
                          }
                          final anio = int.tryParse(value);
                          if (anio == null || anio < 1900 || anio > 2030) {
                            return 'Ingrese un año válido (1900-2030)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imagenUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL de la imagen',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.image),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la URL de la imagen';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: SwitchListTile(
                          title: const Text('Disponible'),
                          subtitle: Text(
                            _disponible
                                ? 'Vehículo disponible'
                                : 'Vehículo no disponible',
                          ),
                          value: _disponible,
                          onChanged: (bool value) {
                            setState(() {
                              _disponible = value;
                            });
                          },
                          secondary: Icon(
                            _disponible ? Icons.check_circle : Icons.cancel,
                            color: _disponible ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Guardar Cambios',
                            style: TextStyle(fontSize: 18),
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
