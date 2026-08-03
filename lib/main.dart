import 'package:flutter/material.dart';
import 'view/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'view/core/app_theme.dart';
import 'Controller/theme_controller.dart';
import 'data/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wajib ditambahkan jika ada pemanggilan async sebelum runApp()
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // Inisialisasi format tanggal untuk bahasa Indonesia
  final themeRepo = ThemeRepository();
  final isDarkInitial = await themeRepo.getThemeMode();

  ThemeController.initTheme(isDarkInitial);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Indri Notes',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
