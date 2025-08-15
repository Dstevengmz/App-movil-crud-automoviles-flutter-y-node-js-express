import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServiceEditarCarro {
  static Future<Map<String, dynamic>> editarCarro(
    String id,
    String marca,
    String modelo,
    int anio,
    bool disponible,
    String imagenUrl,
  ) async {
    final String baseUrl = dotenv.get('URL');
    final url = Uri.parse('$baseUrl/api/carro/$id');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'marca': marca,
        'modelo': modelo,
        'anio': anio,
        'disponible': disponible,
        'imagenUrl': imagenUrl,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {'success': true, 'data': data};
    } else {
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      return {
        'success': false,
        'message':
            data['message'] ??
            'Error al editar el carro (${response.statusCode})',
      };
    }
  }
}
