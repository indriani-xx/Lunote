import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indri_notes/data/database/app_database.dart';
import 'package:indri_notes/helper/priority_helper.dart';
import 'package:indri_notes/view/core/app_color.dart';
import 'package:indri_notes/view/diaolgs/edit_note_dialog.dart';
import 'package:intl/intl.dart';

class NoteDetailDialog extends StatelessWidget {
  final NoteEntry note;
  final VoidCallback onDelete;
  final Function(String, String, int) onEdit;

  const NoteDetailDialog({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy • HH:mm', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priorityColor = PriorityHelper.getColor(note.priority);
    final priorityTextColor = PriorityHelper.getTextColor(note.priority);
    final priorityLabel = PriorityHelper.getLabel(note.priority);
    final cardColor = isDark ? AppColor.darkCard : AppColor.card;
    final textColor = isDark ? AppColor.darkTextPrimary : AppColor.text;
    final mutedColor = isDark ? AppColor.darkTextSecondary : AppColor.muted;
    final primaryColor = isDark ? AppColor.darkPrimary : AppColor.primary;

    return AlertDialog(
      backgroundColor: cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              note.title,
              style: GoogleFonts.manrope(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              priorityLabel,
              style: GoogleFonts.inter(
                color: priorityTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(note.createdAt),
              style: GoogleFonts.inter(
                color: mutedColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(
              height: 24,
              thickness: 1,
              color: mutedColor.withValues(alpha: 0.3),
            ),
            Text(
              note.content,
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
          ),
          tooltip: 'Hapus',
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Tutup',
            style: GoogleFonts.inter(
              color: mutedColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _showEditDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
          label: Text(
            'Edit',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditNoteDialog(note: note, onSave: onEdit),
    );
  }
}
