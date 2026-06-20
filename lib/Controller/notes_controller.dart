import '../model/note.dart';

class NotesController {
  final List<Note> notes = [];

  void addNote(String content) {
    if (content.trim().isEmpty) return;
    notes.add(Note(content: content.trim()));
  }

  void deleteNote(int index) {
    if (index >= 0 && index < notes.length) {
      notes.removeAt(index);
    }
  }
}
