import 'package:flutter/material.dart';
import 'detalleVehiculo.dart';
import 'editarVehiculo.dart';
import 'package:flutter_application_junio5/views/medioPago.dart';
import 'package:flutter_application_junio5/views/menuDrawrs.dart';
import 'mis_alquileres.dart';
import '../services/apiserviciocarro.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  final Color fondo = const Color(0xFF60B5FF);
  final Color primario = Color(0xFF3A7DFF);
  final Color secundario = const Color(0xFFFFECDE);
  final Color detalle = const Color(0xFFFF9149);
  final Color texto = const Color(0xFF000000);

  Future<List<Map<String, dynamic>>> obtenerListaDeAutos() async {
    try {
      return await ApiService.obtenerAutos();
    } catch (e) {
      print("Error al obtener la lista de autos: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: Text("Alquiler de Vehículos"),
        backgroundColor: primario,
        foregroundColor: texto,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: texto),
                hintText: "Buscar vehículo",
                hintStyle: TextStyle(color: texto.withOpacity(0.5)),
                filled: true,
                fillColor: secundario,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: obtenerListaDeAutos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No se encontraron vehículos'));
                  } else {
                    final listaAutos = snapshot.data!;
                    return ListView.builder(
                      itemCount: listaAutos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final auto = listaAutos[index];
                        final id =
                            auto["_id"] is Map
                                ? auto["_id"]["\$oid"]
                                : auto["_id"].toString();
                        final disponibilidad =
                            auto["disponible"] is bool
                                ? auto["disponible"]
                                : (auto["disponible"]
                                            .toString()
                                            .toLowerCase() ==
                                        'true' ||
                                    auto["disponible"] == true);
                        final imageUrl =
                            auto["imageUrl"] ??
                            'https://i.blogs.es/e071a9/captura-de-pantalla-2024-07-17-a-la-s-16.46.16/1200_800.png';
                        final marca = auto["marca"] ?? "Desconocida";
                        final modelo = auto["modelo"] ?? "Desconocido";
                        final anio =
                            auto["anio"] is int
                                ? auto["anio"]
                                : int.tryParse(auto["anio"].toString()) ?? 0;
                        final precio = auto["precio"] ?? 0.0;

                        return ListTile(
                          leading: Image.network(
                            imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            "$marca $modelo",
                            style: TextStyle(
                              color: texto,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Año: $anio"),
                              Text(
                                "Precio por día: \$${precio.toStringAsFixed(2)}",
                              ),
                              Text(
                                "Disponibilidad: ${disponibilidad ? "Disponible" : "No disponible"}",
                                style: TextStyle(
                                  color:
                                      disponibilidad
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  final resultado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EditarVehiculo(
                                            id: id,
                                            marca: marca,
                                            modelo: modelo,
                                            anio: anio,
                                            disponible: disponibilidad,
                                            imagenUrl: imageUrl,
                                          ),
                                    ),
                                  );

                                  // Si se guardaron cambios, recargar la lista
                                  if (resultado == true) {
                                    setState(() {
                                      // Esto hará que el FutureBuilder se ejecute de nuevo
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetalleVehiculo(
                                            carroId: id,
                                            marca: marca,
                                            modelo: modelo,
                                            anio: anio,
                                            disponible: disponibilidad,
                                            imagenUrl: imageUrl,
                                            precio: precio.toDouble(),
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuario'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pago'),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Alquiler',
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuPrincipal()),
            );
          } else if (value == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PerfilUsuario()),
            );
          } else if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MedioPago()),
            );
          } else if (value == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MisAlquileres()),
            );
          }
        },
      ),
    );
  }
}
