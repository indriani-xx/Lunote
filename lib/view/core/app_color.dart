import 'package:flutter/material.dart';

//karena Flutter membutuhkan format Hexadecimal 8 karakter (ARGB) yang menyertakan nilai Opacity (transparansi), bukan hanya 6 karakter (RGB). Kode 05290e yang kamu punya baru berupa RGB biasa.
//tambahkan 0xFF

class AppColor {
  // Mencegah class ini di-instansiasi, di gembok biar tidak bisa dibuat objeknya
  // biar gak buang" memori
  AppColor._();

  static const Color background = Color(
    0xFFF4F6F0,
  ); // Background utama (Cream/Off-White lembut)
  static const Color primary = Color(
    0xFF4A6B5D,
  ); // Aksen utama (Sage Green yang tenang)
  static const Color text = Color(
    0xFF2C3531,
  ); // Teks utama (Charcoal/Dark Slate)
  static const Color card = Color(
    0xFFFFFFFF,
  ); // Kontainer catatan (Pure White agar kontras)
  static const Color muted = Color(
    0xFF7D84B2,
  ); // Teks sekunder / keterangan abu-abu keunguan
  static const Color delete = Color(
    0xFFE63946,
  ); // Warna merah soft untuk tombol hapus
  static const Color primaryLight = Color(
    0xFFE8EFE3,
  ); // Warna hijau muda biar variatif

  // ==========================================
  // 🌙 PALET TEMA GELAP (DARK MODE)
  // ==========================================
  static const Color darkBackground = Color(
    0xFF141716,
  ); // Deep Charcoal dengan hint hijau
  static const Color darkPrimary = Color.fromARGB(
    255,
    6,
    53,
    18,
  ); // Muted Mint (Segar, kontras, & nyaman di mata)
  static const Color darkCard = Color(0xFF1E2421); // Kartu kalender/item
  static const Color darkSurface = Color(0xFF181E1C);  // Bottom Navigation
  static const Color darkTextPrimary = Color(
    0xFFF0F4F2,
  ); // Teks terang (Off-white)
  static const Color darkButton = Color.fromARGB(255, 47, 171, 78);
  static const Color darkTextSecondary = Color(0xFF9AA4A0);
}
