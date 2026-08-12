import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';
import '../../controller/todo_controller.dart';
import '../core/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoController _todoController = TodoController();
  final TextEditingController _todoControllerInput = TextEditingController();
  DateTime selectedDate = DateTime.now();

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(date);
  } // aku makek format tgl indo jd makek ini

  @override
  void dispose() {
    //digunakan untuk membersihkan memori dan mencegah kebocoran data (memory leak) di Flutter.
    _todoControllerInput.dispose();
    super.dispose(); //sistem pembersih bawaan flutter
  }

  //=============== VOID =============
  //FUNGSI MENAMBAH CATATAN
  void _showAddTodoDialog() {
    _todoControllerInput.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tambah Todo Baru',
          style: TextStyle(color: context.textColor),
        ),
        backgroundColor: context.bgColor,
        content: TextField(
          controller: _todoControllerInput,
          decoration: InputDecoration(
            hintText: 'Masukkan tugas baru...',
            hintStyle: TextStyle(
              color: context.textColor.withValues(alpha: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.primaryColor, width: 2),
            ),
          ),
          cursorColor: context.textColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: context.textColor.withValues(alpha: 0.7)),
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
            child: Text('Tambah', style: TextStyle(color: context.textColor)),
          ),
        ],
      ),
    );
  }

  //==================== BUILD MAIN ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: context.primaryColor,
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
              Transform.scale(
                scale: 1.5,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.white,
                    BlendMode.srcIn,
                  ),
                  child: Lottie.asset(
                    'lib/asset/animation/hi.json',
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                    repeat: false,
                  ),
                ),
              ),
              Text(
                'Punya rencana menarik?',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: context.textColor.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(selectedDate),
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: _pickdate,
                      icon: const Icon(Icons.calendar_month),
                      color: context.textColor,
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
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.calendar_month,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Todo-list',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: 15),

              // Dynamic List of Todos
              StreamBuilder<List<Todo>>(
                stream: _todoController.allTodos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final todos = snapshot.data!;
                  if (todos.isEmpty) {
                    return Center(
                      child: Text('Belum ada todo. Buat yang baru!'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return _buildTodoItem(todo);
                    },
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodoItem(Todo todo) {
    final primaryColor = context.primaryColor;
    final textColor = context.textColor;
    final dateBgColor = context.dateBgColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Checkbox Lingkaran
          GestureDetector(
            onTap: () {
              _todoController.toggleTodoDone(todo);
            },
            child: Container(
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor, width: 2),
                color: todo.isDone ? primaryColor : Colors.transparent,
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
                color: dateBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                todo.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  decorationColor: textColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tombol Hapus
          GestureDetector(
            onTap: () {
              setState(() {
                _todoController.deleteTodo(todo.id);
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.delete.withValues(alpha: 0.1),
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

  // ================ DATE =================
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
            final primaryColor = context.primaryColor;
            final textColor = context.textColor;
            final dateBgColor = context.dateBgColor;

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
                      color: isSelected ? primaryColor : dateBgColor,
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
                                  : textColor.withValues(alpha: 0.6),
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
                              color: isSelected ? Colors.white : textColor,
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
}

//=============
//== CATATAN ==
//=============
//1. Hindari late Berlebihan: Kata kunci late digunakan jika nilai variabel baru ada nanti (misalnya di dalam initState). Jika langsung diisi DateTime.now(), tidak perlu pakai late.
