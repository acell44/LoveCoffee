import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/onboarding1.jpg',
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Love Coffee Shop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to our love coffee shop!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
