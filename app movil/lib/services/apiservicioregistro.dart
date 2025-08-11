import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServiceRegistro {
  static Future<Map<String, dynamic>> registrarUsuario(
    String nombre,
    String email,
    String password,
  ) async {
    final url = Uri.parse('http://192.168.20.20:9000/api/user');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nombre,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        print('Error del servidor: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        return {
          'success': false,
          'message':
              data['error'] ?? data['message'] ?? 'Error al registrar usuario',
        };
      }
    } catch (e) {
      print('Error de conexión: $e');
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
