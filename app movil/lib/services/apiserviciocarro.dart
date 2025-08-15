import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<List<Map<String, dynamic>>> obtenerAutos() async {
    final String apiUrl = dotenv.get('URL');
    final url = Uri.parse('$apiUrl/api/carros');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((car) => car as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al obtener autos');
    }
  }
}
