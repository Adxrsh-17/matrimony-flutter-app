import 'package:flutter/material.dart';
import 'shortlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProfileListView(), // custom scrollable view
    const ShortlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Shortlist'),
        ],
      ),
    );
  }
}

class ProfileListView extends StatelessWidget {
  const ProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile Cards List Goes Here"));
  }
}
