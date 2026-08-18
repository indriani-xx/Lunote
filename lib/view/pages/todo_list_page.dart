import 'package:flutter/material.dart';
import 'package:indri_notes/view/widgets/date_picker_widget.dart';
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
  late DateTime selectedDate;
  bool _showAllTodos = false;

  @override
  void initState() {
    super.initState();
    // Normalisasi ke midnight untuk konsistensi perbandingan tanggal
    selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(date);
  } // aku makek format tgl indo jd makek ini

  List<DateTime> _getDateRange() {
    //ngambil tanggal -2 dari hari ini
    return List.generate(
      5,
      (index) => selectedDate.add(Duration(days: index - 2)),
    );
  }

  @override
  void dispose() {
    //digunakan untuk membersihkan memori dan mencegah kebocoran data (memory leak) di Flutter.
    _todoControllerInput.dispose();
    super.dispose(); //sistem pembersih bawaan flutter
  }

  String _formatShortDate(DateTime date) {
    //tgl format indo tanpa hari, untuk tampilan catatan list
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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

              _buildTodosHeader(),
              const SizedBox(height: 15),

              // Dynamic List of Todos
              StreamBuilder<List<Todo>>(
                stream: _todoController.allTodos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.primaryColor,
                      ),
                    );
                  }
                  final todos = snapshot.data!;
                  final filteredTodos = _showAllTodos
                      ? todos
                      : todos
                            .where(
                              (todo) =>
                                  _isSameDay(todo.createdAt, selectedDate),
                            )
                            .toList();

                  if (filteredTodos.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          _showAllTodos
                              ? 'Belum ada todo. Buat yang baru!'
                              : 'Belum ada todo di tanggal ini',
                          style: TextStyle(
                            color: context.mutedTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
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

          // Kotak Isi Todo
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: dateBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: textColor.withValues(alpha: 0.5),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatShortDate(todo.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
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
        // Normalisasi ke midnight agar konsisten
        selectedDate = DateTime(
          pickeddate.year,
          pickeddate.month,
          pickeddate.day,
        );
      });
    }
  }

  // DATE PICKER WIDGET
  Widget _buildDatePicker() {
    final dates = _getDateRange();
    return BoxDatePickerWidget(
      selectedDate: selectedDate,
      dates: dates,
      onDateSelected: (date) {
        setState(() {
          selectedDate = date;
          _showAllTodos = false;
        });
      },
    );
  }

  Widget _buildTodosHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Todo-list',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showAllTodos = true;
            });
          },
          child: Text(
            'See all',
            style: GoogleFonts.inter(
              color: context.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk baris Todo-list
}

//=============
//== CATATAN ==
//=============
//1. Hindari late Berlebihan: Kata kunci late digunakan jika nilai variabel baru ada nanti (misalnya di dalam initState). Jika langsung diisi DateTime.now(), tidak perlu pakai late.
