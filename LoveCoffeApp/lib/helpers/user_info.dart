import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  // Simpen token biar bisa login terus
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Simpen username biar kenal siapa yang login
  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  // Simpen email buat keperluan komunikasi
  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  // Simpen ID biar bisa tracking user
  Future<void> setUserID(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', userID);
  }

  // Ambil token buat autentikasi
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Ambil username, kalo kosong ya default 'User'
  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'User';
  }

  // Ambil email buat keperluan lanjutan
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // Ambil ID user
  Future<String?> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userID');
  }

  // Cek status login, ada token berarti udah login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    // Cek token, kalo ada ya berarti login
    String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  // Logout, hapus semua data user
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Hapus satu-satu data user
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('userID');
  }
}
