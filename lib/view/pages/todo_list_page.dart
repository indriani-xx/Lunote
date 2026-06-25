import 'package:flutter/material.dart';
import '../../Controller/todo_controller.dart';
import '../../model/todo.dart';
import '../core/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoController _todoController = TodoController();
  late DateTime selectedDate = DateTime.now();
  final TextEditingController _todoControllerInput = TextEditingController();

  @override
  void dispose() {
    _todoControllerInput.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    _todoControllerInput.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Todo Baru'),
        backgroundColor: AppColor.background,
        content: TextField(
          controller: _todoControllerInput,
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
              if (_todoControllerInput.text.trim().isNotEmpty) {
                setState(() {
                  _todoController.addTodo(_todoControllerInput.text.trim());
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
              const SizedBox(height: 40),
              Text(
                'Halo!',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              Text(
                'Punya rencana menarik?',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColor.text.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _pickdate,
                      icon: const Icon(Icons.calendar_month),
                      color: AppColor.text,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              _buildDatePicker(),
              const SizedBox(height: 20),

              // 3. MAIN BANNER CARD
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.calendar_month,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

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
              _todoController.todos.isEmpty
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
                      itemCount: _todoController.todos.length,
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

  List<DateTime> _getDateList() {
    List<DateTime> dates = [];
    for (int i = -2; i <= 2; i++) {
      dates.add(selectedDate.add(Duration(days: i)));
    }
    return dates;
  }

  Future<void> _pickdate() async {
    final pickeddate = await showDatePicker(
      // tunggu user memilih tanggal baru muncul DatePicker
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickeddate != null) {
      setState(() {
        selectedDate = pickeddate;
      });
    }
  }

  // DATE PICKER WIDGET
  Widget _buildDatePicker() {
    final dates = _getDateList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: dates.asMap().entries.map((entry) {
            final index = entry.key;
            final date = entry.value;
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

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < dates.length - 1 ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.primary
                          : const Color(0xFFE2E8E4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColor.text.withOpacity(0.6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColor.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Widget untuk baris Todo-list
  Widget _buildTodoItem(int index) {
    final todo = _todoController.todos[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Checkbox Lingkaran
          GestureDetector(
            onTap: () {
              setState(() {
                _todoController.toggleTodoDone(index);
              });
            },
            child: Container(
              width: 44,
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
                _todoController.deleteTodo(index);
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
