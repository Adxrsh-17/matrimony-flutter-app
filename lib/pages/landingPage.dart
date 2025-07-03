import 'package:flutter/material.dart';
import 'home_page.dart';
import 'user_profile.dart';
import 'shortlist_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  String _title = "Welcome";

  final List<Widget> _pages = [
    const WelcomeContent(),
    const HomePage(),
    const ShortlistPage(),
    const UserProfilePage(),
  ];

  void _navigateTo(int index, String title) {
    setState(() {
      _selectedIndex = index;
      _title = title;
    });
    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("💍 Matrimony - Find Your Better Half"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                '👤 Welcome User',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Welcome'),
              onTap: () => _navigateTo(0, "Welcome"),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Browse Profiles'),
              onTap: () => _navigateTo(1, "Browse Profiles"),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Shortlist'),
              onTap: () => _navigateTo(2, "Shortlist"),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () => _navigateTo(3, "My Profile"),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F4FF),
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Where Hearts Meet, Matches are Made',
            style: TextStyle(
              fontSize: 20,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60),
          Text(
            'Find your perfect life partner\nwith trust, values, and love.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
