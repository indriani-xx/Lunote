import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  static const String _keyDarkMode =
      'is_dark_mode'; // Kunci untuk menyimpan status tema di SharedPreferences

  // Fungsi untuk menyimpan status
  Future<void> saveThemeMode(bool isDark) async {
    final prefs =
        await SharedPreferences.getInstance(); //Ini adalah perintah untuk membuka buku catatan (SharedPreferences) tadi. Kata kunci await artinya kita menunggu buku tersebut selesai dibuka.
    await prefs.setBool(
      _keyDarkMode,
      isDark,
    ); //Jika pengguna memilih Dark Mode, fungsi ini akan menulis di halaman _keyDarkMode dengan nilai true
  }

  // BACA: Ambil status tema tersimpan
  Future<bool> getThemeMode() async {
    // megambil status
    final prefs = await SharedPreferences.getInstance(); //buka buku
    return prefs.getBool(_keyDarkMode) ??
        false; //Simbol ?? artinya: Jika datanya kosong(baru pertama kali buka), maka gunakan nilai default false
  }
}
