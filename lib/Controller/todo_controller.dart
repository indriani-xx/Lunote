import '../model/todo.dart';

class TodoController {
  List<Todo> todos = [];

  void addTodo(String title) {
    todos.add(Todo(title: title));
  }

  void toggleTodoDone(int index) {
    todos[index].toggleDone();
  }

  void deleteTodo(int index) {
    todos.removeAt(index);
  }
  //tambahin method notes ama todo
}
