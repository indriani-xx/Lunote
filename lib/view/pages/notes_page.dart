import 'package:flutter/material.dart';
import '../core/app_color.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<String> _notes = [];

  void _addNote() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.card, // Menggunakan AppColor
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Add Note',
            style: TextStyle(
              color: AppColor.text,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: 3,
            cursorColor: AppColor.primary,
            style: const TextStyle(color: AppColor.text),
            decoration: const InputDecoration(
              hintText: 'Tulis catatan...',
              hintStyle: TextStyle(color: AppColor.muted),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.primary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColor.muted),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _notes.add(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background, // Menggunakan AppColor
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Judul Aplikasi
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
              child: Text(
                'My Notes',
                style: TextStyle(
                  color: AppColor.text,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Daftar catatan
            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada catatan',
                        style: TextStyle(color: AppColor.muted, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColor.card,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: const Icon(
                              Icons.notes_rounded,
                              color: AppColor.primary,
                            ),
                            title: Text(
                              _notes[index],
                              style: const TextStyle(
                                color: AppColor.text,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColor.delete,
                              ),
                              onPressed: () => _deleteNote(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: AppColor.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}
