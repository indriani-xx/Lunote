import 'package:flutter/material.dart';
import '../../controller/notes_controller.dart';
import '../core/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesController _notesController = NotesController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _selectedPriority = 1;
  late DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return const Color(0xFFE8F5E9);
      case 2:
        return const Color(0xFFB7D7B0);
      case 3:
        return const Color(0xFF4A6B5D);
      default:
        return const Color(0xFFE8F5E9);
    }
  }

  void _addNote() {
    _titleController.clear();
    _noteController.clear();
    _selectedPriority = 1;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Tambah Catatan',
            style: TextStyle(
              color: AppColor.text,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    cursorColor: AppColor.primary,
                    style: const TextStyle(color: AppColor.text),
                    decoration: const InputDecoration(
                      hintText: 'Judul catatan...',
                      hintStyle: TextStyle(color: AppColor.muted),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    cursorColor: AppColor.primary,
                    style: const TextStyle(color: AppColor.text),
                    decoration: const InputDecoration(
                      hintText: 'Tulis catatan...',
                      hintStyle: TextStyle(color: AppColor.muted),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tingkat pentingnya',
                    style: TextStyle(
                      color: AppColor.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StatefulBuilder(
                    builder: (context, setDialogState) {
                      return Row(
                        children: [1, 2, 3].map((priority) {
                          final isSelected = _selectedPriority == priority;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    _selectedPriority = priority;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? _getPriorityColor(priority)
                                        : AppColor.primaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? _getPriorityColor(priority)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    priority.toString(),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColor.text,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColor.muted),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                final title = _titleController.text.trim();
                final content = _noteController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    _notesController.addNote(title, content, _selectedPriority);
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notesController.deleteNote(index);
    });
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

  Widget _buildDatePicker() {
    final dates = _getDateList();

    return Row(
      children: dates.asMap().entries.map((entry) {
        final index = entry.key;
        final date = entry.value;
        final isSelected =
            date.day == selectedDate.day && date.month == selectedDate.month;
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
            padding: EdgeInsets.only(right: index < dates.length - 1 ? 8 : 0),
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
                              : AppColor.text.withValues(alpha: 0.6),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
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
                  color: AppColor.text,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Catat idemu hari ini!',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColor.text.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              const SizedBox(height: 15),
              _notesController.notes.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'Belum ada catatan',
                          style: TextStyle(color: AppColor.muted, fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: _notesController.notes.length,
                      itemBuilder: (context, index) {
                        final note = _notesController.notes[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColor.card,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: Container(
                              width: 10,
                              height: 48,
                              decoration: BoxDecoration(
                                color: _getPriorityColor(note.priority),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            title: Text(
                              note.judul,
                              style: const TextStyle(
                                color: AppColor.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              note.content,
                              style: const TextStyle(
                                color: AppColor.muted,
                                fontSize: 13,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColor.delete,
                              ),
                              onPressed: () => _deleteNote(index),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: AppColor.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}
