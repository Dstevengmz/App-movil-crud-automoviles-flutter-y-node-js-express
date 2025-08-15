import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiServicioRegistro {
  static Future<Map<String, dynamic>> registrarUsuario(
    String name,
    String email,
    String password,
  ) async {
    final String apiUrl = dotenv.get('URL');
    final url = Uri.parse('$apiUrl/api/register');
    print('URL de registro: $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
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
      if (e is http.ClientException) {
        print('Excepción del cliente: ${e.message}');
      } else if (e is SocketException) {
        print('Excepción de red: ${e.message}');
      } else {
        print('Otro error: ${e.toString()}');
      }
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
