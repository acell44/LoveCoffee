// lib/widgets/bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:lovecoffee/page/menu.dart';
import 'package:lovecoffee/page/home.dart';
import 'package:lovecoffee/page/cart.dart';
import 'package:lovecoffee/page/payment.dart';
import 'package:lovecoffee/page/profile.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Nyimpen halaman aktif
  int _selectedIndex = 0;

  // Daftar halaman buat navigasi
  static List<Widget> _pages = <Widget>[
    HomePage(),
    MenuPage(),
    CartPage(),
    PaymentPage(),
    ProfilePage(),
  ];

  // Ganti halaman pas diklik
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Biar ga reload ulang pas ganti halaman
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Navigation bar kece
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        // Warna indikator dikit transparan biar ga mencolok
        indicatorColor: Color.fromARGB(255, 54, 29, 12).withOpacity(0.2),
        destinations: const <NavigationDestination>[
          // Home
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          // Favorit
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Menu',
          ),
          // Keranjang
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
          ),
          // Pembayaran
          NavigationDestination(
            icon: Icon(Icons.paid_outlined),
            selectedIcon: Icon(Icons.paid_rounded),
            label: 'Payment',
          ),
          // Profil
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
