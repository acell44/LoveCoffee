import 'package:flutter/material.dart';
import 'package:lovecoffee/helpers/user_info.dart';
import 'package:lovecoffee/page/login.dart';
import 'package:lovecoffee/page/register.dart';
import 'package:lovecoffee/page/onboarding1.dart';
import 'package:lovecoffee/page/menu.dart'; // Menambahkan MenuPage
import 'package:lovecoffee/widgets/bottom_navbar.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // Fungsi untuk memeriksa status login
  Future<Widget> _getInitialPage() async {
    bool isLoggedIn = await UserInfo().isLoggedIn();

    print('Is Logged In: $isLoggedIn'); // Debugging

    if (isLoggedIn) {
      return MainApp(); // Jika user sudah login, buka halaman utama
    } else {
      return Onboarding(); // Jika belum login, tampilkan onboarding
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoveCoffee',
      theme: ThemeData(
        colorSchemeSeed: Color.fromARGB(255, 87, 34, 2),
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('An error occurred!')),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Onboarding(); // fallback if there's no data
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => MainApp(),
        '/onboarding': (context) => Onboarding(),
        '/menu': (context) => MenuPage(), // Menambahkan route untuk MenuPage
      },
    );
  }
}
