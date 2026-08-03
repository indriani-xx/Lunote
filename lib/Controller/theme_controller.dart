import 'package:flutter/material.dart';
import '../data/services/theme_service.dart'; // Sesuaikan path jika berbeda

class ThemeController {
  static final ThemeRepository _repo = ThemeRepository();

  // 1. Cukup deklarasikan themeMode SATU KALI saja
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.light,
  );

  // 2. Inisialisasi status tema saat aplikasi pertama dibuka
  static void initTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // 3. Ubah tema sekaligus simpan ke SharedPreferences
  static Future<void> toggleTheme() async {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      await _repo.saveThemeMode(true); // Simpan status dark mode = true
    } else {
      themeMode.value = ThemeMode.light;
      await _repo.saveThemeMode(false); // Simpan status dark mode = false
    }
  }
}
