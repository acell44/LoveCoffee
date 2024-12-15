// lib/services/cart_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lovecoffee/model/item_model.dart';

class CartService {
  // Base URL buat API, biar gampang diubah kalo mau ganti endpoint
  static const String baseUrl =
      'https://675bdbf19ce247eb1937a435.mockapi.io/Item';

  // Ambil semua item di cart
  Future<List<CartItem>> getCartItems() async {
    try {
      // Kirim request GET ke API
      final response = await http.get(Uri.parse(baseUrl));

      // Kalo berhasil, parsing data
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        // Convert json ke list CartItem
        return body.map((item) => CartItem.fromJson(item)).toList();
      } else {
        // Kalo gagal, lempar exception
        throw Exception('Gagal memuat item cart');
      }
    } catch (e) {
      // Tangkep error apapun yang terjadi
      throw Exception('Error: $e');
    }
  }

  Future<bool> updateCartItemQuantity(String itemId, int newQuantity) async {
    try {
      // Kirim request PUT buat update quantity
      final response = await http.put(
        Uri.parse('$baseUrl/$itemId'),
        headers: {'Content-Type': 'application/json'},
        // Kirim data quantity baru
        body: json.encode({'quantity': newQuantity}),
      );

      // Kembalikan true kalo berhasil update
      return response.statusCode == 200;
    } catch (e) {
      // Tangkep error apapun yang terjadi
      throw Exception('Error update quantity: $e');
    }
  }

  // Tambah item ke cart
  Future<CartItem?> addToCart(CartItem item) async {
    try {
      // Kirim request POST dengan data item
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        // Convert item ke JSON buat dikirim
        body: json.encode(item.toJson()),
      );

      // Kalo berhasil (status 200/201), kembalikan item
      if (response.statusCode == 201 || response.statusCode == 200) {
        return CartItem.fromJson(json.decode(response.body));
      } else {
        // Kalo gagal, kembalikan null
        return null;
      }
    } catch (e) {
      // Tangkep error apapun yang terjadi
      throw Exception('Error: $e');
    }
  }

  // Update quantity item di cart
  Future<CartItem?> updateQuantity(int? itemId, int quantity) async {
    // Cek dulu, kalo ID null ya ngga bisa diupdate
    if (itemId == null) return null;

    try {
      // Kirim request PUT buat update quantity
      final response = await http.put(
        Uri.parse('$baseUrl/$itemId'),
        headers: {'Content-Type': 'application/json'},
        // Kirim data quantity baru
        body: json.encode({'quantity': quantity}),
      );

      // Kalo berhasil, kembalikan item yang diupdate
      if (response.statusCode == 200) {
        return CartItem.fromJson(json.decode(response.body));
      } else {
        // Kalo gagal, kembalikan null
        return null;
      }
    } catch (e) {
      // Tangkep error apapun yang terjadi
      throw Exception('Error: $e');
    }
  }

  // Hapus item dari cart
  Future<bool> removeFromCart(String itemId) async {
    try {
      // Kirim request DELETE buat hapus item
      final response = await http.delete(Uri.parse('$baseUrl/$itemId'));
      // Kembalikan true kalo berhasil
      return response.statusCode == 200;
    } catch (e) {
      // Tangkep error apapun yang terjadi
      throw Exception('Error: $e');
    }
  }

  Future<bool> clearCart() async {
    try {
      // Ambil semua item di cart
      final items = await getCartItems();

      // Hapus setiap item
      for (var item in items) {
        await removeFromCart(item.id.toString());
      }

      return true;
    } catch (e) {
      throw Exception('Error clearing cart: $e');
    }
  }
}
