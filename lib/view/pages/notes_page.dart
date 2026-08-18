// notes_page.dart
import 'package:flutter/material.dart';
import 'package:indri_notes/helper/priority_helper.dart';
import 'package:indri_notes/view/diaolgs/add_note_dialog.dart';
import 'package:indri_notes/view/diaolgs/note_detail_dialog.dart';
import 'package:indri_notes/view/widgets/date_picker_widget.dart';
import '../../data/database/app_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controller/notes_controller.dart';
import '../core/app_color.dart';
import 'package:lottie/lottie.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesController _notesController = NotesController();
  DateTime _selectedDate = DateTime.now();
  bool _showAllNotes = false;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    //tgl format indo lebih lengkap
    return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(date);
  }

  String _formatShortDate(DateTime date) {
    //tgl format indo tanpa hari, untuk tampilan catatan list
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  List<DateTime> _getDateRange() {
    //ngambil tanggal -2 dari hari ini
    return List.generate(
      5,
      (index) => _selectedDate.add(Duration(days: index - 2)),
    );
  }

  // ============ DIALOG METHODS ============
  //TAMBAH NOTES
  void _showAddNoteDialog() {
    showDialog(context: context, builder: (context) => AddNoteDialog()).then((
      result,
    ) {
      if (result != null && result is Map) {
        _notesController.addNote(
          title: result['title'],
          content: result['content'],
          priority: result['priority'],
        );
        setState(() {});
      }
    });
  }

  void _showNoteDetail(NoteEntry note) {
    showDialog(
      context: context,
      builder: (context) {
        return NoteDetailDialog(
          note: note,
          onDelete: () {
            setState(() {
              _notesController.deleteNote(note.id);
            });
          },
          onEdit: (newTitle, newContent, priority) {
            setState(() {
              _notesController.editNote(
                oldNote: note,
                newTitle: newTitle,
                newContent: newContent,
                newPriority: priority,
              );
            });
          },
        );
      },
    );
  }

  // ============ MAIN BUILD ============

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
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
        backgroundColor: context.primaryColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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

  Widget _buildDatePicker() {
    final dates = _getDateRange();
    return BoxDatePickerWidget(
      selectedDate: _selectedDate,
      dates: dates,
      onDateSelected: (date) {
        setState(() {
          _selectedDate = date;
          _showAllNotes = false;
        });
      },
    );
  }

  Widget _buildNotesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showAllNotes = true;
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

  Widget _buildNotesList() {
    return StreamBuilder<List<NoteEntry>>(
      stream: _notesController.allNotes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: CircularProgressIndicator(color: context.primaryColor),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                style: TextStyle(color: Colors.red[300], fontSize: 14),
              ),
            ),
          );
        }

        final notes = snapshot.data ?? [];
        final filteredNotes = _showAllNotes
            ? notes
            : notes
                  .where((note) => _isSameDay(note.createdAt, _selectedDate))
                  .toList();

        if (filteredNotes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                _showAllNotes
                    ? 'Belum ada catatan'
                    : 'Belum ada catatan di tanggal ini',
                style: TextStyle(color: context.mutedTextColor, fontSize: 16),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            final note = filteredNotes[index];
            return _buildNoteCard(note);
          },
        );
      },
    );
  }

  //============= WIDGET UI =================

  Widget _buildHeader() {
    //UNTUK TAMPILAN head
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.5,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
              BlendMode.srcIn,
            ),
            child: Lottie.asset(
              //ANIMASI HI!
              'lib/asset/animation/hi.json',
              fit: BoxFit.contain,
              width: 100,
              height: 100,
              repeat: false,
            ),
          ),
        ),
        Text(
          'Catat idemu hari ini!',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: context.textColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          //TGL & ICON TGL
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(_selectedDate),
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
            IconButton(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month),
              color: context.textColor,
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildDatePicker(), //TGL YG KOTAK"
        const SizedBox(height: 20),
      ],
    );
  }

  // CONTAINER BANNER SETELAH TGL KOTAK
  Widget _buildHeroBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(Icons.sticky_note_2, size: 50, color: Colors.white),
    );
  }

  Widget _buildNoteCard(NoteEntry note) {
    final priorityColor = PriorityHelper.getColor(note.priority);
    final priorityTextColor = PriorityHelper.getTextColor(note.priority);
    final priorityLabel = PriorityHelper.getLabel(note.priority);

    return GestureDetector(
      onTap: () => _showNoteDetail(note),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
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
                    // garis warna priority
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
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.mutedTextColor,
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
            Icon(Icons.chevron_right_rounded, color: context.mutedTextColor),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SEPARATE DIALOG WIDGETS
// ============================================================

/// Dialog untuk menampilkan detail catatan

/// Dialog untuk mengedit catatan

/// INI FORM UI ALERTDIALOG REUSABLE (ADD+EDIT)
