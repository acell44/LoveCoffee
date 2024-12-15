import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovecoffee/model/item_model.dart';
import 'package:lovecoffee/services/cart_service.dart';
import 'package:lovecoffee/services/menu_service.dart';

class CoffeeDetailPage extends StatefulWidget {
  final String name;
  final String imagePath;
  final String category;

  const CoffeeDetailPage({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.category,
  }) : super(key: key);

  @override
  _CoffeeDetailPageState createState() => _CoffeeDetailPageState();
}

class _CoffeeDetailPageState extends State<CoffeeDetailPage> {
  // Inisialisasi CartService di dalam state
  final CartService _cartService = CartService();
  final MenuService _favouriteService = MenuService();

  // Variabel untuk ukuran dan jumlah
  String _selectedSize = 'Medium';
  int _quantity = 1;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavourite(); // Periksa status favorit saat halaman dimuat
  }

  Future<void> _checkIfFavourite() async {
    List<dynamic> favourites = await _favouriteService.getFavourites();
    setState(() {
      _isFavourite = favourites.any((item) => item['itemname'] == widget.name);
    });
  }

  // Method untuk menambah/menghapus dari favorit
  Future<void> _toggleFavourite() async {
    final coffeeDetails = _getCoffeeDetails();

    // Persiapkan data item untuk disimpan di favorit
    Map<String, dynamic> favouriteItem = {
      'itemname': widget.name,
      'price': coffeeDetails['price'],
      'category': widget.category,
      'imagePath': widget.imagePath,
    };

    bool result;
    if (_isFavourite) {
      // Jika sudah di favorit, hapus dari favorit
      result = await _favouriteService.removeFromFavourite(widget.name);
    } else {
      // Jika belum di favorit, tambahkan ke favorit
      result =
          await _favouriteService.addToFavourite(widget.name, favouriteItem);
    }

    if (result) {
      setState(() {
        _isFavourite = !_isFavourite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _isFavourite ? 'Added to Favourites' : 'Removed from Favourites'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update favourites'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Deskripsi dan tag berdasarkan nama
  Map<String, dynamic> _getCoffeeDetails() {
    switch (widget.name) {
      case 'Matcha Latte':
        return {
          'tags': ['Coffee', 'Green Tea', 'Medium roasted'],
          'about':
              'Matcha Latte is a drink that combines the deliciousness of japanese green tea powder (matcha) with the creaminess of milk.',
          'price': 10.000,
        };
      case 'Iced Salted Caramel Latte':
        return {
          'tags': ['Coffee', 'Caramel', 'Cold Brew'],
          'about':
              'A refreshing cold latte with a perfect balance of sweet salted caramel and smooth espresso, served over ice.',
          'price': 15.000,
        };
      case 'Chai Latte':
        return {
          'tags': ['Tea', 'Spices', 'Warm Drink'],
          'about':
              'A traditional Indian-style tea blended with aromatic spices like cinnamon, cardamom, and ginger, mixed with steamed milk.',
          'price': 10.000,
        };
      case 'Oat Milk Latte':
        return {
          'tags': ['Coffee', 'Plant-based', 'Dairy Free'],
          'about':
              'A creamy latte made with smooth oat milk, offering a nutty flavor and a sustainable dairy-free alternative.',
          'price': 10.000,
        };
      case 'Peppermint Tea':
        return {
          'tags': ['Herbal', 'Soothing', 'Caffeine-Free'],
          'about':
              'A refreshing herbal tea made from pure peppermint leaves, known for its cooling sensation and digestive benefits. Offers a crisp, minty flavor that helps relax and calm the mind.',
          'price': 10.000,
        };
      case 'Fruit Tea':
        return {
          'tags': ['Fruity', 'Refreshing', 'Cold Drink'],
          'about':
              'A vibrant and refreshing tea infused with a blend of fresh seasonal fruits, perfect for a cool and tangy experience.',
          'price': 10.000,
        };
      case 'Floral Tea':
        return {
          'tags': ['Herbal', 'Delicate', 'Aromatic'],
          'about':
              'A delicate tea blend featuring subtle floral notes, creating a soothing and elegant drinking experience.',
          'price': 10.000,
        };
      case 'Ginger Tea':
        return {
          'tags': ['Herbal', 'Spicy', 'Warming'],
          'about':
              'A warming tea made with fresh ginger, known for its comforting properties and bold, spicy flavor.',
          'price': 10.000,
        };
      case 'French Fries':
        return {
          'tags': ['Snack', 'Crispy', 'Potato'],
          'about':
              'Golden and crispy potato fries, perfectly seasoned and fried to a delightful crunch.',
          'price': 18.000,
        };
      case 'Waffle Ice Cream':
        return {
          'tags': ['Dessert', 'Sweet', 'Cold'],
          'about':
              'A classic dessert featuring a warm, crispy waffle topped with creamy, rich ice cream and sweet toppings.',
          'price': 18.000,
        };
      case 'French Toast':
        return {
          'tags': ['Breakfast', 'Sweet', 'Bread'],
          'about':
              'Soft bread dipped in a rich egg mixture, fried to golden perfection, and served with maple syrup and butter.',
          'price': 18.000,
        };
      case 'Croffle':
        return {
          'tags': ['Pastry', 'Fusion', 'Crispy'],
          'about':
              'A delightful fusion of croissant and waffle, creating a crispy, flaky pastry with a unique texture and flavor.',
          'price': 12.000,
        };
      default:
        return {
          'tags': ['Specialty', 'Unique'],
          'about': 'A delightful culinary experience waiting to be discovered.',
          'price': 10.000,
        };
    }
  }

  void _addToCart() async {
    final coffeeDetails = _getCoffeeDetails();

    CartItem newItem = CartItem(
      itemName: widget.name,
      size: _selectedSize,
      quantity: _quantity,
      price: coffeeDetails['price'],
      category: widget.category,
    );

    try {
      CartItem? addedItem = await _cartService.addToCart(newItem);

      if (addedItem != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added ${_quantity} ${widget.name}(s)\n'
              'Size: $_selectedSize\n'
              'Total: \Rp${(coffeeDetails['price'] * _quantity).toStringAsFixed(3)}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 87, 34, 2),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final coffeeDetails = _getCoffeeDetails();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavourite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavourite,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.name,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk dengan Harga
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Rp${coffeeDetails['price'].toStringAsFixed(3)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 87, 34, 2),
                        ),
                      ),
                    ],
                  ),

                  // Tags
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0;
                            i < coffeeDetails['tags'].length;
                            i++) ...[
                          Text(
                            coffeeDetails['tags'][i],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (i < coffeeDetails['tags'].length - 1)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Container(
                                width: 1.5,
                                height: 20,
                                color: Colors.black,
                              ),
                            ),
                        ]
                      ],
                    ),
                  ),

                  // Ukuran
                  SizedBox(height: 20),
                  Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: ['Small', 'Medium', 'Large'].map((size) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: ChoiceChip.elevated(
                          label: Text(size),
                          selected: _selectedSize == size,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSize = size;
                            });
                          },
                          selectedColor: Color.fromARGB(255, 87, 34, 2),
                          labelStyle: TextStyle(
                            color: _selectedSize == size
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // About
                  SizedBox(height: 20),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    coffeeDetails['about'],
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),

                  // Quantity dan Add to Cart
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Kontrol Quantity di tengah
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                },
                              ),
                              Text(
                                '$_quantity',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Tombol Add to Cart penuh
                      ElevatedButton.icon(
                        onPressed: _addToCart,
                        icon: Icon(color: Colors.white, Icons.shopping_cart),
                        label: Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 87, 34, 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
