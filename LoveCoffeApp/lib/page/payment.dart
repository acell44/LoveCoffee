import 'package:flutter/material.dart';
import 'package:lovecoffee/model/item_model.dart';
import 'package:lovecoffee/services/cart_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  String _selectedDeliveryOption = 'Standard';
  double _totalPrice = 0.0;
  int _deliveryFee = 5000;
  final int _serviceFee = 500;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<CartItem> items = await _cartService.getCartItems();
      double totalPrice = 0.0;

      setState(() {
        _cartItems = items;
        for (var item in _cartItems) {
          totalPrice += (item.price * 1000 * item.quantity).toDouble();
        }
        _totalPrice = totalPrice;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat item keranjang')),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _confirmPayment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resi Pembayaran'),
          content: Text(
              'Pembayaran Anda sebesar Rp${(_totalPrice + _deliveryFee + _serviceFee).toStringAsFixed(0)} telah berhasil.'),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                bool success = await _resetCart();
                if (success) {
                  Navigator.of(context).pop();
                  _fetchCartItems();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Gagal menghapus item dari keranjang')),
                  );
                }

                setState(() {
                  _isLoading = false;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _resetCart() async {
    try {
      return await _cartService.clearCart();
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchCartItems,
            tooltip: 'Refresh Cart',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Jl. Merdeka No. 123, Jakarta Barat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.local_shipping, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Delivery Options',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDeliveryOption = 'Standard';
                              _deliveryFee = 5000;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: _selectedDeliveryOption == 'Standard'
                                    ? Color.fromARGB(255, 87, 34, 2)
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Standard',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '35 Minutes',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Rp 5000',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDeliveryOption = 'Express';
                              _deliveryFee = 10000;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: _selectedDeliveryOption == 'Express'
                                    ? Color.fromARGB(255, 87, 34, 2)
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Express',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '20 Minutes',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Rp 10.000',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: _cartItems
                          .map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item.quantity}x ${item.itemName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${(item.price * 1000 * item.quantity).toString()}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Rincian Pembayaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal'),
                        Text('Rp ${_totalPrice.toStringAsFixed(0)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Pengiriman'),
                        Text('Rp $_deliveryFee'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Layanan'),
                        Text('Rp $_serviceFee'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Rp ${(_totalPrice + _deliveryFee + _serviceFee).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 87, 34, 2),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _confirmPayment();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 87, 34, 2),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 90),
              ),
              child: Text(
                'Konfirmasi Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
