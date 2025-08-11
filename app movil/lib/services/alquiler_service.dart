import 'package:http/http.dart' as http;
import 'dart:convert';

class AlquilerService {
  static const String baseUrl = 'http://192.168.20.20:9000/api';

  static Future<Map<String, dynamic>> crearAlquiler({
    required String usuarioId,
    required String carroId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required double precioTotal,
  }) async {
    final url = Uri.parse('$baseUrl/alquiler');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioId': usuarioId,
          'carroId': carroId,
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin.toIso8601String(),
          'precioTotal': precioTotal,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  static Future<Map<String, dynamic>> obtenerAlquileresUsuario(
    String usuarioId,
  ) async {
    final url = Uri.parse('$baseUrl/alquileres/usuario/$usuarioId');

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  static Future<Map<String, dynamic>> finalizarAlquiler(
    String alquilerId,
  ) async {
    final url = Uri.parse('$baseUrl/alquiler/$alquilerId/finalizar');

    try {
      final response = await http.put(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
