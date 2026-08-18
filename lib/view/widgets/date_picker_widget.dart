import 'package:flutter/material.dart';
import 'package:indri_notes/view/core/app_color.dart';

class BoxDatePickerWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<DateTime> dates;
  final ValueChanged<DateTime> onDateSelected;

  const BoxDatePickerWidget({
    super.key,
    required this.selectedDate,
    required this.dates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Mengambil tema warna dari context agar otomatis mendukung Light/Dark mode
    final primaryColor = context.primaryColor;
    final textColor = context.textColor;
    final dateBgColor = context.dateBgColor; // Sesuaikan dengan warna card Anda

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: dates.asMap().entries.map((entry) {
            final index = entry.key;
            final date = entry.value;

            // Cek kecocokan tanggal, bulan, dan tahun agar lebih akurat
            final isSelected =
                date.day == selectedDate.day &&
                date.month == selectedDate.month &&
                date.year == selectedDate.year;

            final dayName = [
              'Sen',
              'Sel',
              'Rab',
              'Kam',
              'Jum',
              'Sab',
              'Min',
            ][date.weekday - 1];

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < dates.length - 1 ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () =>
                      onDateSelected(date), // Lempar data tanggal keluar widget
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : dateBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : textColor.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
