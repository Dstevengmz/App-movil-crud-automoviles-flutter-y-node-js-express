import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/usuario.dart';
import 'session_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final String baseUrl = dotenv.get('URL');
    final url = Uri.parse('$baseUrl/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final usuario = Usuario.fromJson(data['user']);
      SessionManager.setCurrentUser(usuario);

      return {'success': true, 'data': data, 'user': usuario};
    } else {
      return {
        'success': false,
        'message': data['error'] ?? 'Error desconocido',
      };
    }
  }

  static void logout() {
    SessionManager.clearSession();
  }

  static Future<Usuario> fetchUserById(String id) async {
    final String baseUrl = dotenv.get('URL');
    final url = Uri.parse('$baseUrl/api/user/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromJson(data);
    }
    throw Exception('No se pudo obtener el usuario');
  }

  static Future<Usuario> updateUser({
    required String id,
    String? name,
    String? email,
    String? password,
  }) async {
    final String baseUrl = dotenv.get('URL');
    final url = Uri.parse('$baseUrl/api/user/$id');
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (password != null && password.isNotEmpty) body['password'] = password;

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final updated = Usuario.fromJson(data);
      if (SessionManager.currentUser?.id == updated.id) {
        SessionManager.setCurrentUser(updated);
      }
      return updated;
    }
    throw Exception('No se pudo actualizar el usuario');
  }
}
