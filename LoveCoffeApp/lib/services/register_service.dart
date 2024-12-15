import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Daftar akun baru
Future<Map<String, dynamic>> register(
    String name, String email, String password) async {
  // URL buat register
  final url = Uri.parse('https://675bdbf19ce247eb1937a435.mockapi.io/Users');

  // Kirim data register
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  // Kalo berhasil
  if (response.statusCode == 201) {
    final user = json.decode(response.body);

    // Simpen data di hp biar bisa dipake nanti
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user['id']);
    await prefs.setString('user_name', user['name']);
    await prefs.setString('user_email', user['email']);

    return user; // Balik data user
  } else {
    throw Exception('Gagal daftar');
  }
}

// Masuk akun
Future<Map<String, dynamic>> login(String name, String password) async {
  // URL buat login
  final url = Uri.parse('https://675bdbf19ce247eb1937a435.mockapi.io/Users');

  // Ambil data user
  final response = await http.get(url);

  // Kalo berhasil
  if (response.statusCode == 200) {
    List<dynamic> users = json.decode(response.body); // Parsing data

    // Cari user yang cocok
    final user = users.firstWhere(
      (user) => user['name'] == name && user['password'] == password,
      orElse: () => null,
    );

    // Kalo ketemu
    if (user != null) {
      // Simpen data di hp
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user['id']);
      await prefs.setString('user_name', user['name']);
      await prefs.setString('user_email', user['email']);

      return user; // Balik data user
    } else {
      throw Exception('Login gagal');
    }
  } else {
    throw Exception('Gagal ambil data');
  }
}

// Keluar akun
Future<void> logout() async {
  // Hapus data tersimpan
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
  await prefs.remove('user_name');
  await prefs.remove('user_email');
}
