import 'package:flutter/material.dart';
import 'package:indri_notes/view/diaolgs/note_form_dialog.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int _selectedPriority = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoteFormDialog(
      dialogTitle: 'Tambah Catatan Baru',
      titleController: _titleController,
      contentController: _contentController,
      initialPriority: _selectedPriority,
      onPriorityChanged: (priority) {
        _selectedPriority = priority;
      },
      onSave: () {
        final title = _titleController.text.trim();
        final content = _contentController.text.trim();

        if (title.isNotEmpty && content.isNotEmpty) {
          Navigator.pop(context, {
            //ngirim data ke halaman utama
            'title': title,
            'content': content,
            'priority': _selectedPriority,
          });
        }
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}
