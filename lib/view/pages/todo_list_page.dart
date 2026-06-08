import 'package:flutter/material.dart';
import '../../model/todo.dart';
import '../core/app_color.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todos = [];
  late DateTime selectedDate = DateTime.now();
  final TextEditingController _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    _todoController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Todo Baru'),
        backgroundColor: AppColor.background,
        content: TextField(
          controller: _todoController,
          decoration: InputDecoration(
            hintText: 'Masukkan tugas baru...',
            hintStyle: TextStyle(color: AppColor.text.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
          ),
          cursorColor: AppColor.primary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: AppColor.text.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_todoController.text.isNotEmpty) {
                setState(() {
                  todos.add(Todo(title: _todoController.text, isDone: false));
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Tambah',
              style: TextStyle(color: AppColor.primary),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _getDateList() {
    final now = DateTime.now();
    List<DateTime> dates = [];
    for (int i = -3; i <= 3; i++) {
      dates.add(now.add(Duration(days: i)));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: AppColor.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Halo!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              Text(
                'Punya rencana menarik?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.text.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),

              // DATE PICKER HORIZONTAL
              _buildDatePicker(),
              const SizedBox(height: 30),

              // 3. MAIN BANNER CARD
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(Icons.gps_fixed, color: Colors.white30, size: 80),
                ),
              ),
              const SizedBox(height: 30),

              //TODO LIST SECTION
              const Text(
                'Todo-list',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              const SizedBox(height: 15),

              // Dynamic List of Todos
              todos.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'Belum ada todo. Buat yang baru!',
                          style: TextStyle(
                            color: AppColor.text.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return _buildTodoItem(index);
                      },
                    ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // DATE PICKER WIDGET
  Widget _buildDatePicker() {
    final dates = _getDateList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dates.map((date) {
            final isSelected =
                date.day == selectedDate.day &&
                date.month == selectedDate.month;
            final dayName = [
              'Sen',
              'Sel',
              'Rab',
              'Kam',
              'Jum',
              'Sab',
              'Min',
            ][date.weekday - 1];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.primary
                      : const Color(0xFFE2E8E4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColor.text.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColor.text,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget untuk baris Todo-list
  Widget _buildTodoItem(int index) {
    final todo = todos[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Checkbox Lingkaran
          GestureDetector(
            onTap: () {
              setState(() {
                todo.toggleDone();
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.primary, width: 2),
                color: todo.isDone ? AppColor.primary : Colors.transparent,
              ),
              child: todo.isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Kotak Isi Todo
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8E4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                todo.title,
                style: TextStyle(
                  color: AppColor.text,
                  fontSize: 15,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  decorationColor: AppColor.text.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tombol Hapus
          GestureDetector(
            onTap: () {
              setState(() {
                todos.removeAt(index);
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.delete.withOpacity(0.1),
              ),
              child: Icon(
                Icons.delete_outline,
                color: AppColor.delete,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
