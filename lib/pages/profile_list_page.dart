import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileListPage extends StatelessWidget {
  const ProfileListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.white),
        title: const Text(
          'Matrimony - Find Your Better Half',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.purple[700],
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('iot-matrimony')
            .doc('Users')
            .collection('Profile')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            );
          }

          final profiles = snapshot.data!.docs
              .where((doc) => doc.id != currentUid)
              .toList();

          if (profiles.isEmpty) {
            return const Center(
              child: Text(
                'No profiles available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final data = profiles[index].data() as Map<String, dynamic>;
              final gender = data['gender']?.toString().toLowerCase() ?? 'unknown';
              final seed = data['firstName'] ?? 'user';

              // Load uploaded photo from ImageKit if available
              final List<dynamic> photoList = data['photos'] ?? [];
              final String imageUrl = photoList.isNotEmpty
                  ? photoList.first.toString()
                  : 'https://api.dicebear.com/7.x/${gender.contains('female') ? 'fun-emoji' : 'adventurer'}/png?seed=$seed';

              return Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.purple[100]!, width: 1),
                ),
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Display profile image from ImageKit or fallback avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                      const SizedBox(width: 16),
                      // Profile Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data['firstName'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow('Age', '${data['age'] ?? 'N/A'}'),
                            _buildDetailRow('Gender', '${data['gender'] ?? 'N/A'}'),
                            _buildDetailRow('Language', '${data['language'] ?? 'N/A'}'),
                            _buildDetailRow('Location', '${data['location'] ?? 'N/A'}'),
                            _buildDetailRow('Pincode', '${data['pincode'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.people, color: Colors.purple),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.pink),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
