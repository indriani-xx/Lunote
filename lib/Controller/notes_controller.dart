import '../model/note.dart';

class NotesController {
  final List<Note> notes = [];

  void addNote(String judul, String content, int priority) {
    if (judul.trim().isEmpty || content.trim().isEmpty) return;

    final safePriority = priority.clamp(1, 3);
    notes.add(
      Note(
        judul: judul.trim(),
        content: content.trim(),
        priority: safePriority,
      ),
    );
  }

  void deleteNote(int index) {
    if (index >= 0 && index < notes.length) {
      notes.removeAt(index);
    }
  }

  void editNote(int index, String judul, String content, int priority) {
    if (index < 0 || index >= notes.length) return;
    if (judul.trim().isEmpty || content.trim().isEmpty) return;

    final safePriority = priority.clamp(1, 3);
    notes[index] = Note(
      judul: judul.trim(),
      content: content.trim(),
      priority: safePriority,
    );
  }

  void showNote(int index) {
    if (index < 0 || index >= notes.length) return;
    final note = notes[index];
    print('Judul: ${note.judul}');
    print('Content: ${note.content}');
    print('Priority: ${note.priority}');
  }
}
