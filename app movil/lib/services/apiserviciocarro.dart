import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<List<Map<String, dynamic>>> obtenerAutos() async {
    final url = Uri.parse('http://192.168.20.20:9000/api/carros');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((car) => car as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al obtener autos');
    }
  }
}
