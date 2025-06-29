import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final Map<String, dynamic> user;
  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user['image']),
              radius: 40,
            ),
            const SizedBox(height: 10),
            Text(user['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${user['age']} years old'),
            Text(user['profession']),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: List.generate(user['interests'].length, (i) {
                return Chip(label: Text(user['interests'][i]));
              }),
            )
          ],
        ),
      ),
    );
  }
}
