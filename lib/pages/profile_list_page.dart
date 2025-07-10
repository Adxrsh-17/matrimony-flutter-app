import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart'; // Ensure this is the correct import

class ProfileListPage extends StatefulWidget {
  const ProfileListPage({super.key});

  @override
  State<ProfileListPage> createState() => _ProfileListPageState();
}

class _ProfileListPageState extends State<ProfileListPage> {
  final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
  Set<String> shortlistedUids = {};

  @override
  void initState() {
    super.initState();
    _loadShortlistedUids();
  }

  Future<void> _loadShortlistedUids() async {
    if (currentUid == null) return;
    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading shortlist: $e')),
      );
    }
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

    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating shortlist: $e')),
      );
    }
  }

  Widget _defaultAvatar() {
    return const CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(
        'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Placeholder for getOrCreateChatBox (define this function)
  Future<String> getOrCreateChatBox(String currentUid, String profileUid) async {
    final chatId = _generateChatId(currentUid, profileUid);
    final chatRef = FirebaseFirestore.instance
        .collection('iot-matrimony')
        .doc('Chats')
        .collection('Metadata')
        .doc(chatId);

    final doc = await chatRef.get();
    if (!doc.exists) {
      await chatRef.set({
        'users': [currentUid, profileUid],
        'createdAt': FieldValue.serverTimestamp(),
        'unreadCount': 0, // Initialize unread count
      });
    }
    return chatId; // Return chatId as chatBoxId
  }

  String _generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }

  @override
  Widget build(BuildContext context) {
    if (currentUid == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view profiles.')),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('iot-matrimony')
            .doc('Users')
            .collection('Profile')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No profiles available.'));
          }

          final profiles = snapshot.data!.docs
              .where((doc) => doc.id != currentUid)
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final doc = profiles[index];
              final data = doc.data() as Map<String, dynamic>;
              var profileUid = doc.id;
              final isShortlisted = shortlistedUids.contains(profileUid);

              // Ensure firstName is fetched and handled
              final displayName = data['firstName']?.isNotEmpty == true
                  ? data['firstName']
                  : 'Unnamed User'; // Fallback if firstName is null or empty

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: data['photos'] != null &&
                            data['photos'] is List &&
                            data['photos'].isNotEmpty
                            ? Image.network(
                          data['photos'][0],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _defaultAvatar(),
                        )
                            : _defaultAvatar(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
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
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chat, color: Colors.deepPurple),
                            onPressed: () async {
                              final chatId = _generateChatId(currentUid!, profileUid);
                              final chatDoc = await FirebaseFirestore.instance
                                  .collection('iot-matrimony')
                                  .doc('Chats')
                                  .collection('Metadata')
                                  .doc(chatId)
                                  .get();

                              if (!chatDoc.exists || chatDoc.data()?['accepted'] == true) {
                                String chatBoxId =
                                await getOrCreateChatBox(currentUid!, profileUid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      currentUserId: currentUid!,
                                      chatBoxId: chatBoxId,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Chat is not accepted yet."),
                                  ),
                                );
                              }
                            },
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
}