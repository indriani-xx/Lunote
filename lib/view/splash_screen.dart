import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Mengatur durasi splash screen selama 3 detik sebelum ke HomePage
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue, // Ubah warna sesuai selera
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan logo aplikasi kamu
            Icon(Icons.note_alt, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Indri Notes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 171, 24, 24),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white), // Animasi loading
          ],
        ),
      ),
    );
  }
}
