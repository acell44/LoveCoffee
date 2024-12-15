import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Spacer(
            flex: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "But first, let me drink my"
                  "\ncoffee",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Create an account or log in to enjoy the pleasure"
                  "\nof the best cup of coffee",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/Coffee.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Tombol Create Account dan Login
          Spacer(flex: 50),
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      backgroundColor: Color.fromARGB(255, 87, 34, 2),
                      padding: const EdgeInsets.all(15.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 50.0),
            padding: const EdgeInsets.only(left: 150, right: 150),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 87, 34, 2),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
