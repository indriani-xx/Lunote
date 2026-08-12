//Pusaka ini agar aplikasi Flutter kamu bisa menjalankan proses berat di latar belakang tanpa membuat layar aplikasi macet (freeze)
//Digunakan untuk menunda eksekusi kode atau membuat proses berulang
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view/core/app_color.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // timer 5 detik lalu pindah ke home
    Timer(const Duration(seconds: 5), () {
      // apakah splash screen nya ditutup?
      // return = 2. JAWABAN YA: "Stop! Berhenti di sini! Jangan lanjut ke bawah!"
      if (!mounted) return;
      // 3. JAWABAN TIDAK (artinya mounted = true, alias widget masih aktif di layar):
      // Lewati baris return di atas, lalu jalankan perintah di bawah ini:
      Navigator.pushReplacement(
        //pushReplacement = pindah ke halaman baru, yg lama di hancur kan
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //menyimpan logo ke dlm variabel,kode di bagian bawah (body aplikasi) akan menjadi lebih bersih dan rapi.
    final logo = Image.asset(
      'lib/asset/logocathi.png',
      width: 150,
      height: 150,
      errorBuilder: (context, error, stackTrace) {
        // jaga" kalok logo gak bisa dimuat, nanti bakal muncul container bkn kotak merah error
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(child: Text('Logo not found')),
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAF6F0), // Soft Vanilla
              Color(0xFFF0E5D8), // Warm Oat / Cream
              Color(0xFFFAF6F0),
            ], // Soft Vanilla
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Saat aplikasi dibuka, logo tidak langsung muncul mengagetkan,
                  // melainkan muncul samar-samar dari ukuran agak kecil, lalu membesar
                  //sedikit ke ukuran asli secara mulus selama 0,65 detik.
                  TweenAnimationBuilder<double>(
                    //TweenAnimationBuilder = widget bawaan Flutter untuk membuat animasi sederhana tanpa perlu membuat controller sendiri
                    tween: Tween(
                      begin: 0,
                      end: 1,
                    ), //Ini adalah mesin hitung yang akan menghitung angka dari 0 sampai 1 secara bertahap, misal 0.1 0.2
                    duration: const Duration(
                      milliseconds: 650,
                    ), //Menentukan durasi kecepatan animasi.
                    curve: Curves
                        .easeOutCubic, //membuat animasi bergerak cepat di awal lalu melambat secara halus di akhir
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 0.9 + (value * 0.1),
                          child: child,
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: logo,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * 10),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      'Lunote －O－',
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColor.text,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _SplashProgress(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashProgress extends StatelessWidget {
  const _SplashProgress();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: LinearProgressIndicator(
                //widget yang di dalam nya ada animasi garis bergerak dari kiri ke kanan t
                minHeight: 8,
                backgroundColor: AppColor.primaryLight,
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Loading...',
          style: GoogleFonts.inter(
            color: AppColor.text.withValues(alpha: 0.55),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
