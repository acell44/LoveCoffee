import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenuService {
  // Base URL buat API, biar gampang diubah kalo mau ganti endpoint
  final String baseUrl = 'https://675bdbf19ce247eb1937a435.mockapi.io/Users';

  // Simpen ID user biar bisa dipake nanti
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Ambil ID user yang lagi login
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    // Cetak buat debug, biar tau aja ID-nya
    print('Stored User ID: $userId');

    return userId;
  }

  // Tambahin item ke favorit
  Future<bool> addToFavourite(
      String itemId, Map<String, dynamic> itemDetails) async {
    try {
      // Cek dulu ID user
      String? userId = await _getUserId();

      // Debug print biar tau proses
      print('Attempting to add to favourites. User ID: $userId');

      // Kalo ngga ada user ID, lempar error
      if (userId == null || userId.isEmpty) {
        throw Exception('Belum login nih, login dulu ya!');
      }

      // Ambil data user
      final response = await http.get(Uri.parse('$baseUrl/$userId'));

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);

        // Siap-siap list favorit, kalo kosong ya bikin baru
        List<dynamic> favourites = userData['favourites'] ?? [];

        // Cek duluan, jangan sampe dobel
        bool isExists = favourites
            .any((item) => item['itemname'] == itemDetails['itemname']);
        if (isExists) {
          print('Item udah ada di favorit');
          return false;
        }

        // Tambahin item baru ke favorit
        favourites.add({'id': itemId, ...itemDetails});

        // Update data user di MockAPI
        final updateResponse = await http.put(
          Uri.parse('$baseUrl/$userId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({...userData, 'favourites': favourites}),
        );

        print('Status update favorit: ${updateResponse.statusCode}');
        return updateResponse.statusCode == 200;
      }

      print('Gagal ambil data user. Status: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Error nambah ke favorit: $e');
      return false;
    }
  }

  // Ambil daftar favorit
  Future<List<dynamic>> getFavourites() async {
    try {
      // Cek user ID
      String? userId = await _getUserId();
      if (userId == null) {
        throw Exception('Belum login nih');
      }

      // Ambil data user
      final response = await http.get(Uri.parse('$baseUrl/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);
        return userData['favourites'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error ambil favorit: $e');
      return [];
    }
  }

  // Hapus item dari favorit
  Future<bool> removeFromFavourite(String itemId) async {
    try {
      // Cek user ID
      String? userId = await _getUserId();
      if (userId == null) {
        throw Exception('Belum login nih');
      }

      // Ambil data user
      final response = await http.get(Uri.parse('$baseUrl/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);

        // Siap-siap list favorit
        List<dynamic> favourites = userData['favourites'] ?? [];

        // Hapus item dari favorit
        favourites.removeWhere((item) => item['id'] == itemId);

        // Update data user di MockAPI
        final updateResponse = await http.put(
          Uri.parse('$baseUrl/$userId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({...userData, 'favourites': MenuService}),
        );

        return updateResponse.statusCode == 200;
      }
      return false;
    } catch (e) {
      print('Error hapus dari favorit: $e');
      return false;
    }
  }
}
