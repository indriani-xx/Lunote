import '../data/database/app_database.dart';

class TodoController {
  final AppDatabase _db = AppDatabase();

  Stream<List<Todo>> get allTodos => _db.watchAllTodos();

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    final newTodo = TodosCompanion.insert(title: title.trim());
    await _db.insertTodo(newTodo);
  }

  Future<void> deleteTodo(int id) async {
    await _db.deleteTodo(id);
  }

  Future<bool> toggleTodoDone(Todo todo) async {
    final updatedTodo = todo.copyWith(isDone: !todo.isDone);
    return _db.updateTodo(updatedTodo);
  }
}

//tambahin method notes ama todo
