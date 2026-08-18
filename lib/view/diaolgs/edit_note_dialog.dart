import 'package:flutter/material.dart';
import 'package:indri_notes/data/database/app_database.dart';
import 'package:indri_notes/view/diaolgs/note_form_dialog.dart';

class EditNoteDialog extends StatefulWidget {
  final NoteEntry note;
  final Function(String, String, int) onSave;

  const EditNoteDialog({super.key, required this.note, required this.onSave});

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _selectedPriority = widget.note.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoteFormDialog(
      dialogTitle: 'Edit Catatan',
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
          widget.onSave(title, content, _selectedPriority);
          Navigator.pop(context);
        }
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}
