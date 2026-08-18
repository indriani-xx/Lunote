import 'package:flutter/material.dart';
import 'view/splash_screen.dart';
//Secara default, Flutter hanya mengenali format tanggal dalam bahasa Inggris (AS).
//Jika Anda ingin mengubah tanggal menjadi "Senin, 7 Agustus 2026" (bahasa Indonesia)
//dan bukan "Monday, August 7, 2026", Anda wajib memanggil fungsi dari package ini.
import 'package:intl/date_symbol_data_local.dart';
import 'view/core/app_theme.dart';
import 'controller/theme_controller.dart';
import 'data/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wajib ditambahkan jika ada pemanggilan async sebelum runApp()
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // Inisialisasi format tanggal untuk bahasa Indonesia
  final themeRepo =
      ThemeRepository(); //Repositori ini bertugas sebagai kurir untuk mengambil atau menyimpan status tema ke dalam penyimpanan lokal HP
  final isDarkInitial = await themeRepo
      .getThemeMode(); //Mengambil data tema yang tersimpan secara asynchronous (await).

  ThemeController.initTheme(
    isDarkInitial,
  ); //Memasukkan hasil pengecekan tadi ke dalam pengatur tema aplikasi

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      //=====ValueListenableBuilder, yang merupakan fitur bawaan Flutter untuk mendengarkan perubahan data secara langsung===
      valueListenable:
          ThemeController.themeMode, //Menunjuk ke variabel utama yang dipantau
      //===Fungsi yang akan dieksekusi setiap kali ada perubahan tema===
      builder:
          (
            context,
            currentMode, //berisi status tema terbaru yang sedang aktif
            child,
          ) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode:
                  currentMode, //ini didapat dari ValueListenableBuilder. Jika nilainya ThemeMode.dark, Flutter otomatis mengaktifkan desain dari AppTheme.darkTheme
              home: const SplashScreen(),
            );
          },
    );
  }
}
