import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {
    'name': 'Priya Sharma',
    'age': 22,
    'profession': 'UI/UX Designer',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Colors.pink),
            const SizedBox(height: 10),
            Text(user['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("${user['age']} years old"),
            Text(user['profession']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      user: user,
                      onSave: (updatedUser) {
                        setState(() {
                          user = updatedUser;
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text("Edit Profile"),
            )
          ],
        ),
      ),
    );
  }
}
