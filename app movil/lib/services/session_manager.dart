import '../models/usuario.dart';

class SessionManager {
  static Usuario? _currentUser;

  static Usuario? get currentUser => _currentUser;

  static void setCurrentUser(Usuario user) {
    _currentUser = user;
  }

  static void clearSession() {
    _currentUser = null;
  }

  static bool get isLoggedIn => _currentUser != null;

  static String? get currentUserId => _currentUser?.id;
}
