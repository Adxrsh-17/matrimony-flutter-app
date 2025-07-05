import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShortlistPage extends StatelessWidget {
  const ShortlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Shortlisted Profiles'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('iot-matrimony')
            .doc('Users')
            .collection('Shortlist')
            .doc(currentUid)
            .collection('Profiles')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profiles = snapshot.data?.docs ?? [];

          if (profiles.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final doc = profiles[index];
              final data = doc.data() as Map<String, dynamic>;
              final profileId = doc.id;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(
                      (data['photos'] != null &&
                          data['photos'] is List &&
                          data['photos'].isNotEmpty)
                          ? data['photos'][0]
                          : 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                    ),
                  ),
                  title: Text(data['firstName'] ?? 'Unknown'),
                  subtitle: Text('Age: ${data['age'] ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Remove from shortlist',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Remove from Shortlist'),
                          content: const Text('Are you sure you want to remove this profile?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await FirebaseFirestore.instance
                            .collection('iot-matrimony')
                            .doc('Users')
                            .collection('Shortlist')
                            .doc(currentUid)
                            .collection('Profiles')
                            .doc(profileId)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('❌ Removed from shortlist')),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    // Optionally navigate to profile detail page
                  },
                ),
              );
            },
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
