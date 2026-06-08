import 'package:flutter/material.dart';

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
}
