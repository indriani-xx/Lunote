import 'package:flutter/material.dart';
import 'pages/notes_page.dart';
import 'pages/todo_list_page.dart';
import 'core/app_color.dart';
import '../../Controller/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex =
      0; //tanda garis bawah _ berarti fungsi ini bersifat rahasia/private, hanya bisa dipakai di dalam file kode ini saja

  static const List<Widget> _pages = [NotesPage(), TodoPage()];

  void _onItemTapped(int index) {
    //Flutter otomatis mendeteksi tombol keberapa yang kamu tekan (0, 1, atau 2) lalu memasukkan angka tersebut ke dalam variabel bernama index ini
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation:
            0, // Menghilangkan garis/bayangan bawah agar tetap terkesan 'clean'
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme
            .textTheme
            .bodyLarge
            ?.color, //ika tema bodyLarge memiliki pengaturan warna, gunakan warna itu. Jika ternyata kosong (null), gunakan warna bawaan sistem agar aplikasi tidak error.
        actions: [
          ValueListenableBuilder<ThemeMode>(
            //=====ValueListenableBuilder, yang merupakan fitur bawaan Flutter untuk mendengarkan perubahan data secara langsung===
            valueListenable: ThemeController.themeMode,
            builder: (context, currentMode, child) {
              final isDarkMode = currentMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(
                  isDarkMode
                      ? Icons
                            .light_mode_rounded //saat mode gelap aktif, icon yg muncul icon light
                      : Icons.dark_mode_rounded, //begitu sebaliknya
                ),
                onPressed: () {
                  ThemeController.toggleTheme();
                },
                tooltip: isDarkMode ? 'Mode Terang' : 'Mode Gelap',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: isDark
              ? AppColor.darkSurface
              : const Color.fromRGBO(255, 255, 255, 1),
          elevation: 0, //menghilangkan garis di atas nav
          type: BottomNavigationBarType
              .fixed, //Membuat posisi tombol tetap dan tidak bergerak atau bergeser saat ditekan
          currentIndex:
              _selectedIndex, // Menandai tombol mana yang sedang aktif atau dipilih saat ini berdasarkan angka dari variabel _selectedIndex.
          onTap: _onItemTapped,
          selectedItemColor: isDark
              ? AppColor.darkButton
              : AppColor.primary, //warna icon nav kalok di pilih
          unselectedItemColor:
              isDark //warna icon kalok gak ddi pilih
              ? Colors.grey
              : AppColor.muted.withValues(alpha: 0.6),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          items: const [
            //list icon
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.notes_rounded),
              ),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.assignment_turned_in_rounded),
              ),
              label: 'Todo',
            ),
          ],
        ),
      ),
    );
  }
}
