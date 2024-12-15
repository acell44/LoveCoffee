import 'package:flutter/material.dart';
import 'package:lovecoffee/services/login_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key untuk form validation
  bool _isLoading = false; // Variabel untuk status loading

  // Fungsi untuk memanggil API Login
  void _login() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Memanggil login() dari login_service.dart untuk memeriksa login via API
        final result = await LoginService()
            .login(name, password); // Gunakan LoginService()

        if (result) {
          // Login berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Color.fromARGB(255, 87, 34, 2),
            ),
          );

          // Navigasi ke halaman home
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          // Login gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid username or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        print("Login error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian kiri atas dengan icon dan teks di bawahnya
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Agar elemen di bawahnya rata kiri
                children: [
                  Container(
                    padding:
                        EdgeInsets.all(10.0), // Padding untuk memperbesar kotak
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 87, 34, 2), // Latar belakang hijau
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: Icon(
                      Icons.lock, // Menggunakan icon kunci untuk login
                      color: Colors.white, // Warna icon putih
                      size: 30.0,
                    ),
                  ),
                  SizedBox(height: 10.0), // Jarak antara icon dan teks "Login"
                  Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                      height: 5.0), // Jarak antara teks "Login" dan deskripsi
                  Text(
                    "Enter your information to access your account.",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),

              // Form Login
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextFormField(
                    // Ganti TextField dengan TextFormField
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Vira Febriana",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextFormField(
                    // Ganti TextField dengan TextFormField
                    controller: _passwordController,
                    obscureText:
                        true, // Menggunakan karakter tersembunyi untuk password
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              Spacer(),

              // Tombol Login (bagian bawah)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _login, // Panggil fungsi login saat tombol ditekan
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 87, 34, 2),
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Tombol Register
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "Don't have an account? Register now",
                      style: TextStyle(
                        color: Color.fromARGB(255, 87, 34, 2),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
