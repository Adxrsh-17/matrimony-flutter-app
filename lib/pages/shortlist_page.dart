import 'package:flutter/material.dart';

class ShortlistPage extends StatelessWidget {
  const ShortlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual shortlist data
    final List<Map<String, String>> shortlistedProfiles = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Shortlisted Profiles'),
        backgroundColor: Colors.deepPurple,
      ),
      body: shortlistedProfiles.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shortlistedProfiles.length,
        itemBuilder: (context, index) {
          final profile = shortlistedProfiles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                ),
                radius: 26,
              ),
              title: Text(profile['name'] ?? 'Unknown'),
              subtitle: Text('Age: ${profile['age'] ?? 'N/A'}'),
              trailing: const Icon(Icons.favorite, color: Colors.red),
              onTap: () {
                // Navigate to profile details
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.favorite_border, size: 80, color: Colors.deepPurple),
          SizedBox(height: 20),
          Text(
            'No profiles shortlisted yet.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}