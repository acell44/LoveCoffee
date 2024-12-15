import 'package:dio/dio.dart';
import 'package:lovecoffee/helpers/user_info.dart';

class LoginService {
  final Dio _dio = Dio();
  final String _apiUrl = 'https://675bdbf19ce247eb1937a435.mockapi.io/Users';

  // Proses login
  Future<bool> login(String username, String password) async {
    try {
      // Ambil data user dari API
      Response response = await _dio.get(_apiUrl);

      // Cek data ada atau ngga
      if (response.data != null && response.data.isNotEmpty) {
        for (var user in response.data) {
          // Cocokkan username sama password
          if (user['name'] == username && user['password'] == password) {
            // Login sukses! Simpen data user
            String token = DateTime.now()
                .millisecondsSinceEpoch
                .toString(); // Token dadakan
            await UserInfo().setToken(token);
            await UserInfo().setUsername(user['name']);
            await UserInfo().setEmail(user['email']);
            await UserInfo().setUserID(user['id'].toString());
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      // Kalo error, cetak di console
      print('Login error: $e');
      return false;
    }
  }
}
