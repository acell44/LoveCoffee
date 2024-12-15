import 'package:flutter/material.dart';
import 'package:lovecoffee/services/register_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller buat nyimpen input user
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Key buat validasi form, biar input user bener
  final _formKey = GlobalKey<FormState>();

  // Fungsi register, dipanggil pas tombol register diklik
  void _register() async {
    // Cek dulu, input udah bener belom
    if (_formKey.currentState!.validate()) {
      // Ambil value dari input, hapus spasi di depan/belakang
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Panggil service buat register
        final result = await register(name, email, password);
        print("User berhasil didaftar: $result");

        // Kalo berhasil, langsung ke halaman login
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } catch (error) {
        print("Registrasi gagal: $error");
        // Kalo gagal, kasih tau user pake snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal! Coba lagi.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cegah layout berantakan pas keyboard muncul
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          // Pasang form key buat validasi
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section - logo + judul
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container buat icon
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 87, 34, 2), // Warna hijau kece
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded biar keren
                    ),
                    child: Icon(
                      Icons.air, // Icon angin, biar fresh gitu 😎
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(height: 10.0), // Sedikit jarak
                  Text(
                    "Register",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "Masukkan data kamu biar bisa nikmatin fitur kece.",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),

              // Form input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Name
                  Text("Name",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600)),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Nama Asli",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    // Validasi nama wajib diisi
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),

                  // Input Email
                  Text("Email",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600)),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "name@gmail.com",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // Validasi email
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email harus diisi';
                      }
                      // Cek format email pake regex
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Format email salah';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),

                  // Input Password
                  Text("Password",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600)),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, // Sembunyiin password
                    decoration: InputDecoration(
                      hintText: "Masukkan password",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    // Validasi password
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password harus diisi';
                      }
                      if (value.trim().length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              Spacer(), // Biar tombol ada di bawah

              // Tombol Register & Login
              Column(
                children: [
                  // Tombol Register
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 87, 34, 2),
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Tombol pindah ke Login
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Udah punya akun? Login sekarang",
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
