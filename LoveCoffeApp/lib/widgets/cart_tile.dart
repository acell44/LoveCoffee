// lib/widgets/cart_tile.dart
import 'package:flutter/material.dart';
import 'package:lovecoffee/model/item_model.dart';
import 'package:lovecoffee/services/cart_service.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final Function(CartItem) onUpdate;

  const CartTile({
    Key? key,
    required this.cartItem,
    required this.onRemove,
    required this.onUpdate,
  }) : super(key: key);

  // Konversi nama item menjadi nama file gambar
  String _getImageNameFromItemName(String itemName) {
    // Hapus spasi dari nama item
    String imageName = itemName.replaceAll(' ', '');

    // Tambahkan ekstensi .jpg
    return '$imageName.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200], // Warna latar belakang abu-abu
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar atau ikon produk
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/${_getImageNameFromItemName(cartItem.itemName)}'),
                  fit: BoxFit.cover,
                ),
                color:
                    Colors.white, // Warna background jika gambar gagal dimuat
              ),
              child: cartItem.itemName.isEmpty
                  ? Icon(Icons.coffee,
                      color: Color.fromARGB(255, 54, 29, 12), size: 40)
                  : null, // Tampilkan ikon jika tidak ada gambar
            ),

            const SizedBox(width: 16),

            // Informasi produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.itemName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cartItem.size} | Rp ${cartItem.price.toStringAsFixed(3)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Kontrol kuantitas
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Warna latar belakang kontrol kuantitas
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 20),
                    onPressed: cartItem.quantity > 1
                        ? () => _updateQuantity(cartItem.quantity - 1)
                        : null,
                  ),
                  Text(
                    '${cartItem.quantity}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 20),
                    onPressed: () => _updateQuantity(cartItem.quantity + 1),
                  ),
                ],
              ),
            ),

            // Tombol hapus
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }

  // Metode untuk memperbarui kuantitas item di keranjang
  void _updateQuantity(int newQuantity) async {
    final cartService = CartService();
    try {
      // Coba perbarui kuantitas melalui layanan keranjang
      final updatedItem =
          await cartService.updateQuantity(cartItem.id, newQuantity);

      // Perbarui item jika berhasil
      if (updatedItem != null) {
        onUpdate(updatedItem);
      }
    } catch (e) {
      // Tangani kesalahan saat pembaruan
      print('Gagal update kuantitas: $e');
    }
  }
}
