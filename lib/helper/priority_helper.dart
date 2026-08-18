import 'package:flutter/material.dart';

class PriorityHelper {
  final priorityColor = PriorityHelper();
  static Color getColor(int priority) {
    // warna bg tulisan teks priority
    switch (priority) {
      case 3: // Tinggi
        return const Color(0xFFFFECEB);
      case 2: // Sedang
        return const Color(0xFFFFF4E5);
      case 1: // Rendah
      default:
        return const Color(0xFFE8F5E9);
    }
  }

  static Color getTextColor(int priority) {
    //warna priority
    switch (priority) {
      case 3:
        return const Color(0xFFD32F2F);
      case 2:
        return const Color(0xFFE65100);
      case 1:
      default:
        return const Color(0xFF2E7D32);
    }
  }

  static String getLabel(int priority) {
    //teks priority
    switch (priority) {
      case 3:
        return 'Tinggi';
      case 2:
        return 'Sedang';
      case 1:
      default:
        return 'Rendah';
    }
  }
}
