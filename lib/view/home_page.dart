import 'package:flutter/material.dart';
import 'pages/notes_page.dart';
import 'core/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    NotesPage(),
    Center(
      child: Text('Halaman Todo'),
    ), // Nanti ini bisa kamu ganti ke TodoPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background, // Set background utama di sini
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        // Dibungkus container agar kita bisa memberi bayangan halus di navigasi bawah
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColor.card, // Warna dasar putih bersih
          elevation: 0, // Matikan shadow bawaan yang kaku
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColor.primary, // Warna Sage Green saat aktif
          unselectedItemColor: AppColor.muted.withOpacity(
            0.6,
          ), // Warna redup saat tidak aktif
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
                child: Icon(
                  Icons.assignment_turned_in_rounded,
                ), // Icon todo yang lebih clean
              ),
              label: 'Todo',
            ),
          ],
        ),
      ),
    );
  }
}
