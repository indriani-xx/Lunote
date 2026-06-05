import 'package:flutter/material.dart';
import '../../model/todo.dart';
import '../core/app_color.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key, required this.todos, required this.onTodoTap});

  final List<Todo> todos;
  final void Function(Todo) onTodoTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(todos[index].title),
          child: SizedBox(
            child: Row(
              children: [
                Text(todos[index].title),
                Spacer(),
                Icon(
                  todos[index].isDone
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
