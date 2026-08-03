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
  int _selectedIndex = 0;

  static const List<Widget> _pages = [NotesPage(), TodoPage()];

  void _onItemTapped(int index) {
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
        foregroundColor: theme.textTheme.bodyLarge?.color,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.themeMode,
            builder: (context, currentMode, child) {
              final isDarkMode = currentMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
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
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: isDark ? AppColor.darkButton : AppColor.primary,
          unselectedItemColor: isDark
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
