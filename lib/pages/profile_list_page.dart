import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileListPage extends StatefulWidget {
  const ProfileListPage({super.key});

  @override
  State<ProfileListPage> createState() => _ProfileListPageState();
}

class _ProfileListPageState extends State<ProfileListPage> {
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  Set<String> shortlistedUids = {};

  @override
  void initState() {
    super.initState();
    _loadShortlistedUids();
  }

  Future<void> _loadShortlistedUids() async {
    if (currentUid == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('iot-matrimony')
        .doc('Users')
        .collection('Shortlist')
        .doc(currentUid)
        .collection('Profiles')
        .get();

    setState(() {
      shortlistedUids = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  Future<void> _toggleShortlist(String profileUid, Map<String, dynamic> data) async {
    if (currentUid == null) return;

    final ref = FirebaseFirestore.instance
        .collection('iot-matrimony')
        .doc('Users')
        .collection('Shortlist')
        .doc(currentUid)
        .collection('Profiles')
        .doc(profileUid);

    final exists = await ref.get();

    if (!exists.exists) {
      await ref.set(data);
      shortlistedUids.add(profileUid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Added to Shortlist")),
      );
    } else {
      await ref.delete();
      shortlistedUids.remove(profileUid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Removed from Shortlist")),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matrimony - Find Your Better Half"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('iot-matrimony')
            .doc('Users')
            .collection('Profile')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profiles = snapshot.data!.docs
              .where((doc) => doc.id != currentUid)
              .toList();

          if (profiles.isEmpty) {
            return const Center(
              child: Text('No profiles available.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final doc = profiles[index];
              final data = doc.data() as Map<String, dynamic>;
              final profileUid = doc.id;
              final isShortlisted = shortlistedUids.contains(profileUid);

              return Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                ),
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image
                      if (data['photos'] != null &&
                          data['photos'] is List &&
                          data['photos'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            data['photos'][0],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                          ),
                        ),
                      const SizedBox(width: 16),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data['firstName'] ?? 'Unknown'}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildDetailRow('Age', '${data['age'] ?? 'N/A'}'),
                            _buildDetailRow('Gender', '${data['gender'] ?? 'N/A'}'),
                            _buildDetailRow('Language', '${data['language'] ?? 'N/A'}'),
                            _buildDetailRow('Location', '${data['location'] ?? 'N/A'}'),
                            _buildDetailRow('Pincode', '${data['pincode'] ?? 'N/A'}'),
                          ],
                        ),
                      ),

                      // Shortlist button
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.people, color: Colors.purple),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              isShortlisted ? Icons.favorite : Icons.favorite_border,
                              color: Colors.pink,
                            ),
                            onPressed: () {
                              _toggleShortlist(profileUid, data);
                            },
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple)),
          Text(value,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}
