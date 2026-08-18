import 'package:flutter/foundation.dart';
import '../data/database/app_database.dart';

class NotesController {
  final AppDatabase _db = AppDatabase();

  Stream<List<NoteEntry>> get allNotes => _db.watchAllNotes();

  Future<void> addNote({
    required String title,
    required String content,
    required int priority,
  }) async {
    if (title.trim().isEmpty || content.trim().isEmpty) return;

    final safePriority = priority.clamp(1, 3);
    final noteBaru = NotesCompanion.insert(
      title: title.trim(),
      content: content.trim(),
      priority: safePriority,
      createdAt: DateTime.now(),
    );
    await _db.insertNote(noteBaru);
  }

  Future<void> deleteNote(int id) async {
    await _db.deleteNote(id);
  }

  Future<void> editNote({
    required NoteEntry oldNote,
    required String newTitle,
    required String newContent,
    required int newPriority,
  }) async {
    if (newTitle.trim().isEmpty || newContent.trim().isEmpty) return;

    final updatedNote = oldNote.copyWith(
      title: newTitle.trim(),
      content: newContent.trim(),
      priority: newPriority.clamp(1, 3),
    );

    await _db.updateNote(updatedNote);
  }

  void showNote(NoteEntry note) {
    debugPrint('Title: ${note.title}');
    debugPrint('Content: ${note.content}');
    debugPrint('Priority: ${note.priority}');
  }

  void dispose() {
    _db.close();
  }
}
