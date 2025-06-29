import 'package:flutter/material.dart';
import 'matched_page.dart';
import 'shortlist_page.dart';
import 'profile_page.dart';
import 'profile_list_page.dart'; // ✅ Correct import for All Profiles page

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matrimony Home"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: const Center(
        child: Text(
          "Welcome to Matrimony Home",
          style: TextStyle(fontSize: 18),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/3177/3177440.png',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Priya Sharma",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Matches"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MatchedPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text("Shortlisted"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShortlistPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("My Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("All Profiles"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileListPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
