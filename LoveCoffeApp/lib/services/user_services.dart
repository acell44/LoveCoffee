import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/user.dart';

class UserService {
  // Daftar akun baru
  Future<User?> register(User user) async {
    try {
      // Kirim data user ke backend
      final Response response =
          await ApiClient().post('users', data: user.toJson());
      // Balik lagi datanya kalo berhasil
      return User.fromJson(response.data);
    } catch (e) {
      // Kalo error, cetak di console
      print('Registration error: $e');
      return null;
    }
  }

  // Proses login
  Future<bool> login(String name, String password) async {
    try {
      // Ambil semua user dari backend
      final Response response = await ApiClient().get('users');
      final List users = response.data;

      // Cari user yang cocok
      var matchedUser = users.firstWhere(
        (u) => u['name'] == name && u['password'] == password,
        orElse: () => null,
      );

      // Balik status login
      return matchedUser != null;
    } catch (e) {
      // Kalo error, cetak di console
      print('Login error: $e');
      return false;
    }
  }
}
