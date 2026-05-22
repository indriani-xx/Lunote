class Todo {
  String title;
  bool isDone;

  Todo({required this.title, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
