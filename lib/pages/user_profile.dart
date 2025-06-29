import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    userData = Map<String, dynamic>.from(widget.user);
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          user: userData,
          onSave: (updatedUser) {
            setState(() {
              userData = updatedUser;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4EC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userData['image']),
              backgroundColor: Colors.pinkAccent,
            ),
            const SizedBox(height: 16),
            Text(
              userData['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text("Age: ${userData['age']}"),
            Text("Profession: ${userData['profession']}"),
            Text("Interests: ${userData['interests'].join(', ')}"),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text("Edit", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              onPressed: _editProfile,
            )
          ],
        ),
      ),
    );
  }
}
