import 'package:flutter/material.dart';
import 'package:lovecoffee/model/item_model.dart';
import 'package:lovecoffee/services/cart_service.dart';
import 'package:lovecoffee/widgets/cart_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final items = await _cartService.getCartItems();
      setState(() {
        _cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  double _calculateTotal() {
    return _cartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }

  void _removeItem(CartItem item) async {
    try {
      bool removed = await _cartService.removeFromCart(item.id.toString());
      if (removed) {
        setState(() {
          _cartItems.remove(item);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal hapus item: $e')),
      );
    }
  }

  void _updateItemQuantity(CartItem updatedItem) async {
    try {
      bool updated = await _cartService.updateCartItemQuantity(
          updatedItem.id.toString(), updatedItem.quantity);

      if (updated) {
        setState(() {
          int index =
              _cartItems.indexWhere((item) => item.id == updatedItem.id);
          if (index != -1) {
            _cartItems[index] = updatedItem;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update quantity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCartItems,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _cartItems.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: 250),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Keranjang kosong',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Silakan tambahkan produk ke keranjang',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          return CartTile(
                            cartItem: _cartItems[index],
                            onRemove: () => _removeItem(_cartItems[index]),
                            onUpdate: _updateItemQuantity,
                          );
                        },
                      ),
      ),
    );
  }
}
