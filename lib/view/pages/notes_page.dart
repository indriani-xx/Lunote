// notes_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controller/notes_controller.dart';
import '../../model/note.dart';
import '../core/app_color.dart';
import 'package:lottie/lottie.dart';

/// Helper terpusat untuk skema warna & label priority
class PriorityHelper {
  static Color getColor(int priority) {
    switch (priority) {
      case 3: // Tinggi
        return const Color(0xFFFFECEB);
      case 2: // Sedang
        return const Color(0xFFFFF4E5);
      case 1: // Rendah
      default:
        return const Color(0xFFE8F5E9);
    }
  }

  static Color getTextColor(int priority) {
    switch (priority) {
      case 3:
        return const Color(0xFFD32F2F);
      case 2:
        return const Color(0xFFE65100);
      case 1:
      default:
        return const Color(0xFF2E7D32);
    }
  }

  static String getLabel(int priority) {
    switch (priority) {
      case 3:
        return 'Tinggi';
      case 2:
        return 'Sedang';
      case 1:
      default:
        return 'Rendah';
    }
  }
}

/// Halaman utama untuk menampilkan dan mengelola catatan
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesController _notesController = NotesController();
  late DateTime _selectedDate = DateTime.now();

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
    final priorityColor = PriorityHelper.getColor(note.priority);
    final priorityTextColor = PriorityHelper.getTextColor(note.priority);
    final priorityLabel = PriorityHelper.getLabel(note.priority);

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
              color: Colors.black.withValues(alpha: 0.05),
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
                color: priorityTextColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      priorityLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: priorityTextColor,
                      ),
                    ),
                  ),
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
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatShortDate(note.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
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
        Transform.scale(
          scale: 2,
          child: SizedBox(
            width: 90,
            height: 90,
            child: Lottie.asset(
              'lib/asset/animation/hi.json',
              fit: BoxFit.contain,
              repeat: false,
            ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(_selectedDate),
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
    return Text(
      'Notes',
      style: GoogleFonts.manrope(
        fontSize: 20,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
      dialogTitle: 'Tambah Catatan Baru',
      titleController: _titleController,
      contentController: _contentController,
      initialPriority: _selectedPriority,
      onPriorityChanged: (priority) {
        _selectedPriority = priority;
      },
      onSave: () {
        final title = _titleController.text.trim();
        final content = _contentController.text.trim();

        if (title.isNotEmpty && content.isNotEmpty) {
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

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy • HH:mm', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = PriorityHelper.getColor(note.priority);
    final priorityTextColor = PriorityHelper.getTextColor(note.priority);
    final priorityLabel = PriorityHelper.getLabel(note.priority);

    return AlertDialog(
      backgroundColor: AppColor.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              note.judul,
              style: GoogleFonts.manrope(
                color: AppColor.text,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              priorityLabel,
              style: GoogleFonts.inter(
                color: priorityTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(note.createdAt),
              style: GoogleFonts.inter(
                color: AppColor.muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(height: 24, thickness: 1),
            Text(
              note.content,
              style: GoogleFonts.inter(
                color: AppColor.text,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
          ),
          tooltip: 'Hapus',
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Tutup',
            style: GoogleFonts.inter(
              color: AppColor.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _showEditDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
          label: Text(
            'Edit',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
      dialogTitle: 'Edit Catatan',
      titleController: _titleController,
      contentController: _contentController,
      initialPriority: _selectedPriority,
      onPriorityChanged: (priority) {
        _selectedPriority = priority;
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
class NoteFormDialog extends StatefulWidget {
  final String dialogTitle;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final int initialPriority;
  final ValueChanged<int> onPriorityChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const NoteFormDialog({
    super.key,
    required this.dialogTitle,
    required this.titleController,
    required this.contentController,
    required this.initialPriority,
    required this.onPriorityChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<NoteFormDialog> createState() => _NoteFormDialogState();
}

class _NoteFormDialogState extends State<NoteFormDialog> {
  late int _currentPriority;

  @override
  void initState() {
    super.initState();
    _currentPriority = widget.initialPriority;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.all(16),
      title: Text(
        widget.dialogTitle,
        style: GoogleFonts.manrope(
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
              const SizedBox(height: 16),
              _buildContentField(),
              const SizedBox(height: 20),
              Text(
                'Tingkat Prioritas',
                style: GoogleFonts.inter(
                  color: AppColor.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              _buildPrioritySelector(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            'Batal',
            style: GoogleFonts.inter(
              color: AppColor.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: widget.onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Simpan',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: widget.titleController,
      cursorColor: AppColor.primary,
      style: GoogleFonts.inter(color: AppColor.text),
      decoration: InputDecoration(
        hintText: 'Judul catatan...',
        hintStyle: GoogleFonts.inter(color: AppColor.muted),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: widget.contentController,
      maxLines: 4,
      cursorColor: AppColor.primary,
      style: GoogleFonts.inter(color: AppColor.text),
      decoration: InputDecoration(
        hintText: 'Tulis isi catatan...',
        hintStyle: GoogleFonts.inter(color: AppColor.muted),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [1, 2, 3].map((priorityValue) {
        final isSelected = _currentPriority == priorityValue;
        final bgColor = PriorityHelper.getColor(priorityValue);
        final textColor = PriorityHelper.getTextColor(priorityValue);
        final label = PriorityHelper.getLabel(priorityValue);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentPriority = priorityValue;
                });
                widget.onPriorityChanged(priorityValue);
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? bgColor
                      : Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? textColor : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? textColor : AppColor.muted,
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
                    : AppColor.text.withValues(alpha: 0.6),
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
