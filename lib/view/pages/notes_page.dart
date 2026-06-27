// notes_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controller/notes_controller.dart';
import '../../model/note.dart';
import '../core/app_color.dart';

/// Halaman utama untuk menampilkan dan mengelola catatan
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // ============ CONTROLLER & STATE ============
  final NotesController _notesController = NotesController();
  late DateTime _selectedDate = DateTime.now();

  // ============ LIFECYCLE ============
  @override
  void dispose() {
    super.dispose();
  }

  // ============ HELPER METHODS ============

  Color _getPriorityColor(int priority) {
    const colors = {
      1: Color(0xFFE8F5E9),
      2: Color(0xFFB7D7B0),
      3: Color(0xFF4A6B5D),
    };
    return colors[priority] ?? const Color(0xFFE8F5E9);
  }

  String _getPriorityLabel(int priority) {
    const labels = {1: 'Rendah', 2: 'Sedang', 3: 'Tinggi'};
    return labels[priority] ?? 'Rendah';
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(date);
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  List<DateTime> _getDateRange() {
    return List.generate(
      5,
      (index) => _selectedDate.add(Duration(days: index - 2)),
    );
  }

  // ============ DIALOG METHODS ============

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddNoteDialog(),
    ).then((result) {
      if (result != null && result is Map) {
        _notesController.addNote(
          result['title'],
          result['content'],
          result['priority'],
        );
        setState(() {});
      }
    });
  }

  void _showNoteDetail(int index) {
    if (index < 0 || index >= _notesController.notes.length) return;

    showDialog(
      context: context,
      builder: (context) => NoteDetailDialog(
        note: _notesController.notes[index],
        onDelete: () {
          setState(() {
            _notesController.deleteNote(index);
          });
        },
        onEdit: (newTitle, newContent, priority) {
          setState(() {
            _notesController.editNote(index, newTitle, newContent, priority);
          });
        },
      ),
    );
  }

  // ============ DATE PICKER ============

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // ============ WIDGET BUILDERS ============

  Widget _buildDatePicker() {
    final dates = _getDateRange();
    const weekDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Row(
      children: dates.asMap().entries.map((entry) {
        final index = entry.key;
        final date = entry.value;
        final isSelected =
            date.day == _selectedDate.day && date.month == _selectedDate.month;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < dates.length - 1 ? 8 : 0),
            child: _DatePickerItem(
              dayName: weekDays[date.weekday - 1],
              dayNumber: date.day.toString(),
              isSelected: isSelected,
              onTap: () => setState(() => _selectedDate = date),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoteCard(Note note, int index) {
    return GestureDetector(
      onTap: () => _showNoteDetail(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 60,
              decoration: BoxDecoration(
                color: _getPriorityColor(note.priority),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColor.muted,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatShortDate(note.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColor.muted),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
            color: AppColor.text.withOpacity(0.7),
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
                DateFormat('d/M/yyyy').format(_selectedDate),
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              IconButton(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                color: AppColor.text,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildDatePicker(),
        const SizedBox(height: 20),
      ],
    );
  }

  // ============ MAIN BUILD ============

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
              _buildHeader(),
              _buildHeroBanner(),
              const SizedBox(height: 20),
              _buildNotesHeader(),
              const SizedBox(height: 15),
              _buildNotesList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: AppColor.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(Icons.sticky_note_2, size: 50, color: Colors.white),
    );
  }

  Widget _buildNotesHeader() {
    return const Text(
      'Notes',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.text,
      ),
    );
  }

  Widget _buildNotesList() {
    if (_notesController.notes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'Belum ada catatan',
            style: TextStyle(color: AppColor.muted, fontSize: 16),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _notesController.notes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(_notesController.notes[index], index);
      },
    );
  }
}

// ============================================================
// SEPARATE DIALOG WIDGETS
// ============================================================

/// Dialog untuk menambah catatan baru
class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int _selectedPriority = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoteFormDialog(
      title: 'Tambah Catatan',
      titleController: _titleController,
      contentController: _contentController,
      initialPriority: _selectedPriority,
      onPriorityChanged: (priority) {
        setState(() {
          _selectedPriority = priority;
        });
      },
      onSave: () {
        final title = _titleController.text.trim();
        final content = _contentController.text.trim();

        if (title.isNotEmpty && content.isNotEmpty) {
          // TODO: Panggil controller untuk menyimpan
          // Untuk sementara kita gunakan Navigator untuk return data
          Navigator.pop(context, {
            'title': title,
            'content': content,
            'priority': _selectedPriority,
          });
        }
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}

/// Dialog untuk menampilkan detail catatan
class NoteDetailDialog extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final Function(String, String, int) onEdit;

  const NoteDetailDialog({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });

  Color _getPriorityColor(int priority) {
    const colors = {
      1: Color(0xFFE8F5E9),
      2: Color(0xFFB7D7B0),
      3: Color(0xFF4A6B5D),
    };
    return colors[priority] ?? const Color(0xFFE8F5E9);
  }

  String _getPriorityLabel(int priority) {
    const labels = {1: 'Rendah', 2: 'Sedang', 3: 'Tinggi'};
    return labels[priority] ?? 'Rendah';
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),

      title: Text(
        note.judul,
        style: GoogleFonts.manrope(
          color: AppColor.text,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.content,
            style: GoogleFonts.inter(color: AppColor.text, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Text(
            _formatDate(note.createdAt),
            style: GoogleFonts.inter(
              color: AppColor.text.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getPriorityColor(note.priority),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Priority ${note.priority} - ${_getPriorityLabel(note.priority)}',
              style: const TextStyle(
                color: AppColor.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColor.muted)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _showEditDialog(context);
          },
          child: const Text(
            'Edit',
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditNoteDialog(note: note, onSave: onEdit),
    );
  }
}

/// Dialog untuk mengedit catatan
class EditNoteDialog extends StatefulWidget {
  final Note note;
  final Function(String, String, int) onSave;

  const EditNoteDialog({super.key, required this.note, required this.onSave});

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.judul);
    _contentController = TextEditingController(text: widget.note.content);
    _selectedPriority = widget.note.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoteFormDialog(
      title: 'Edit Catatan',
      titleController: _titleController,
      contentController: _contentController,
      initialPriority: _selectedPriority,
      onPriorityChanged: (priority) {
        setState(() {
          _selectedPriority = priority;
        });
      },
      onSave: () {
        final title = _titleController.text.trim();
        final content = _contentController.text.trim();

        if (title.isNotEmpty && content.isNotEmpty) {
          widget.onSave(title, content, _selectedPriority);
          Navigator.pop(context);
        }
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}

/// Form dialog reusable untuk tambah dan edit catatan
class NoteFormDialog extends StatelessWidget {
  final String title;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final int initialPriority;
  final ValueChanged<int> onPriorityChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const NoteFormDialog({
    super.key,
    required this.title,
    required this.titleController,
    required this.contentController,
    required this.initialPriority,
    required this.onPriorityChanged,
    required this.onSave,
    required this.onCancel,
  });

  Color _getPriorityColor(int priority) {
    const colors = {
      1: Color(0xFFE8F5E9),
      2: Color(0xFFB7D7B0),
      3: Color(0xFF4A6B5D),
    };
    return colors[priority] ?? const Color(0xFFE8F5E9);
  }

  String _getPriorityLabel(int priority) {
    const labels = {1: 'Rendah', 2: 'Sedang', 3: 'Tinggi'};
    return labels[priority] ?? 'Rendah';
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        int priority = initialPriority;

        return AlertDialog(
          backgroundColor: AppColor.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          title: Text(
            title,
            style: const TextStyle(
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
                  _buildTitleField(),
                  const SizedBox(height: 12),
                  _buildContentField(),
                  const SizedBox(height: 12),
                  _buildPriorityLabel(),
                  const SizedBox(height: 8),
                  _buildPrioritySelector(
                    context: context,
                    setState: setState,
                    priority: priority,
                    onPriorityChanged: (newPriority) {
                      priority = newPriority;
                      onPriorityChanged(newPriority);
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: onCancel,
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColor.muted),
              ),
            ),
            TextButton(
              onPressed: onSave,
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: titleController,
      cursorColor: AppColor.primary,
      style: const TextStyle(color: AppColor.text),
      decoration: const InputDecoration(
        hintText: 'Judul catatan...',
        hintStyle: TextStyle(color: AppColor.muted),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: contentController,
      maxLines: 3,
      cursorColor: AppColor.primary,
      style: const TextStyle(color: AppColor.text),
      decoration: const InputDecoration(
        hintText: 'Tulis catatan...',
        hintStyle: TextStyle(color: AppColor.muted),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildPriorityLabel() {
    return const Text(
      'Tingkat pentingnya',
      style: TextStyle(color: AppColor.text, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildPrioritySelector({
    required BuildContext context,
    required StateSetter setState,
    required int priority,
    required ValueChanged<int> onPriorityChanged,
  }) {
    return Row(
      children: [1, 2, 3].map((priorityValue) {
        final isSelected = priority == priorityValue;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  priority = priorityValue;
                  onPriorityChanged(priorityValue);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getPriorityColor(priorityValue)
                      : AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _getPriorityColor(priorityValue)
                        : Colors.transparent,
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      priorityValue.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColor.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isSelected)
                      Text(
                        _getPriorityLabel(priorityValue),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
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
}

/// Widget untuk item date picker
class _DatePickerItem extends StatelessWidget {
  final String dayName;
  final String dayNumber;
  final bool isSelected;
  final VoidCallback onTap;

  const _DatePickerItem({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : const Color(0xFFE2E8E4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : AppColor.text.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              dayNumber,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColor.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
