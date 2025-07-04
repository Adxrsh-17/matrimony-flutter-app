import 'package:flutter/material.dart';
import 'shortlist_page.dart';
import 'profile_list_page.dart'; // 🔁 Import actual profile view

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;
  final List<Widget> _tabPages = [
    const ProfileListPage(), // 🔁 Replaced ProfileListView
    const ShortlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabPages[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Shortlist',
          ),
        ],
      ),
    );
  }
}
