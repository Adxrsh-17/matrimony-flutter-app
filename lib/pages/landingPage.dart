import 'package:flutter/material.dart';
import 'home_page.dart';
import 'user_profile.dart';
import 'shortlist_page.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💍 Matrimony - Find Your Better Half"),
        backgroundColor: const Color(0xFF8E24AA),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6A1B9A)),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background_image.jpg',
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Matrimony App',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Where Hearts Meet, Matches are Made',
                  style: GoogleFonts.caveat(
                    fontSize: 24,
                    color: Colors.pinkAccent,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text(
                  'Find your perfect life partner\nwith trust, values, and love.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}