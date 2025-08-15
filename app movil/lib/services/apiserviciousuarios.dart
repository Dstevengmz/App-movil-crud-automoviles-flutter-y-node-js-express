import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiServicioUsuarios {
  static Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final String apiUrl = dotenv.get('URL');
    final Uri url = Uri.parse('$apiUrl/api/users');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    throw Exception('Error al obtener usuarios (${response.statusCode})');
  }
}
