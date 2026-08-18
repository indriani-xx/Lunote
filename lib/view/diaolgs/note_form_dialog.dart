import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indri_notes/helper/priority_helper.dart';
import 'package:indri_notes/view/core/app_color.dart';

class NoteFormDialog extends StatefulWidget {
  final String dialogTitle;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final int initialPriority;
  final ValueChanged<int> onPriorityChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const NoteFormDialog({
    super.key,
    required this.dialogTitle,
    required this.titleController,
    required this.contentController,
    required this.initialPriority,
    required this.onPriorityChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<NoteFormDialog> createState() => _NoteFormDialogState();
}

class _NoteFormDialogState extends State<NoteFormDialog> {
  late int _currentPriority;

  @override
  void initState() {
    super.initState();
    _currentPriority = widget.initialPriority;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColor.darkCard : AppColor.card;
    final textColor = isDark ? AppColor.darkTextPrimary : AppColor.text;
    final mutedColor = isDark ? AppColor.darkTextSecondary : AppColor.muted;
    final primaryColor = isDark ? AppColor.darkPrimary : AppColor.primary;

    return AlertDialog(
      backgroundColor: cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.all(16),
      title: Text(
        widget.dialogTitle,
        style: GoogleFonts.manrope(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(textColor, mutedColor, primaryColor),
              const SizedBox(height: 16),
              _buildContentField(textColor, mutedColor, primaryColor),
              const SizedBox(height: 20),
              Text(
                'Tingkat Prioritas',
                style: GoogleFonts.inter(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              _buildPrioritySelector(mutedColor),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            'Batal',
            style: GoogleFonts.inter(
              color: mutedColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: widget.onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Simpan',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(
    Color textColor,
    Color mutedColor,
    Color primaryColor,
  ) {
    return TextField(
      controller: widget.titleController,
      cursorColor: primaryColor,
      style: GoogleFonts.inter(color: textColor),
      decoration: InputDecoration(
        hintText: 'Judul catatan...',
        hintStyle: GoogleFonts.inter(color: mutedColor),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildContentField(
    Color textColor,
    Color mutedColor,
    Color primaryColor,
  ) {
    return TextField(
      controller: widget.contentController,
      maxLines: 4,
      cursorColor: primaryColor,
      style: GoogleFonts.inter(color: textColor),
      decoration: InputDecoration(
        hintText: 'Tulis isi catatan...',
        hintStyle: GoogleFonts.inter(color: mutedColor),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(Color mutedColor) {
    return Row(
      children: [1, 2, 3].map((priorityValue) {
        final isSelected = _currentPriority == priorityValue;
        final bgColor = PriorityHelper.getColor(priorityValue);
        final textColor = PriorityHelper.getTextColor(priorityValue);
        final label = PriorityHelper.getLabel(priorityValue);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentPriority = priorityValue;
                });
                widget.onPriorityChanged(priorityValue);
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? bgColor
                      : Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? textColor : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? textColor : mutedColor,
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
  }
}
