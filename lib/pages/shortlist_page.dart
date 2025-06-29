import 'package:flutter/material.dart';

class ShortlistPage extends StatelessWidget {
  final List<Map<String, dynamic>> shortlistedUsers;

  const ShortlistPage({super.key, required this.shortlistedUsers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shortlisted Profiles')),
      body: shortlistedUsers.isEmpty
          ? const Center(child: Text('No shortlisted profiles yet.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: shortlistedUsers.length,
        itemBuilder: (context, index) {
          final user = shortlistedUsers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(user['image'])),
              title: Text(user['name']),
              subtitle: Text('Age: ${user['age']} | ${user['profession']}'),
            ),
          );
        },
      ),
    );
  }
}