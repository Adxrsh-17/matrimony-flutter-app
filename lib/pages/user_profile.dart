import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'chat_page.dart';
import 'edit_profile_page.dart';


class UserProfilePage extends StatefulWidget {
  final String? userId;

  const UserProfilePage({super.key, this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with SingleTickerProviderStateMixin {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  late final String targetUserId;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    targetUserId = widget.userId ?? currentUserId!;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchProfile(String uid) async {
    return await FirebaseFirestore.instance
        .collection('iot-matrimony')
        .doc('Users')
        .collection('Profile')
        .doc(uid)
        .get();
  }

  void _navigateToEditProfile() {
    if (targetUserId == currentUserId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditProfilePage(userId: targetUserId),
        ),
      );
    }
  }

  void _startChat() async {
    if (currentUserId == null || targetUserId == currentUserId) return;
    final chatBoxId = await getOrCreateChatBox(currentUserId!, targetUserId);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          currentUserId: currentUserId!,
          chatBoxId: chatBoxId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please log in to view profiles.'),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Log In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("User Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (targetUserId == currentUserId)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: _navigateToEditProfile,
            ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _fetchProfile(targetUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Error loading profile'));
          }

          final data = snapshot.data!.data()!;
          final String name = data['firstName'] ?? 'Unknown';
          final String? gender = data['gender']?.toLowerCase();
          final String imageUrl = (data['photos'] != null &&
              data['photos'] is List &&
              data['photos'].isNotEmpty)
              ? data['photos'][0]
              : (gender == 'male'
              ? 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'
              : gender == 'female'
              ? 'https://cdn-icons-png.flaticon.com/512/3135/3135626.png'
              : 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png');

          final String bio = data['bio'] ?? 'No bio available';
          final String maritalStatus = data['maritalStatus'] ?? 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: CachedNetworkImageProvider(imageUrl),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow('Age', '${data['age'] ?? 'N/A'}'),
                          _buildDetailRow('Gender', '${data['gender'] ?? 'N/A'}'),
                          _buildDetailRow('Language', '${data['language'] ?? 'N/A'}'),
                          _buildDetailRow('Location', '${data['location'] ?? 'N/A'}'),
                          _buildDetailRow('Pincode', '${data['pincode'] ?? 'N/A'}'),
                          _buildDetailRow('Marital Status', maritalStatus),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.userId != null && widget.userId != currentUserId)
                    ElevatedButton.icon(
                      onPressed: _startChat,
                      icon: const Icon(Icons.chat),
                      label: const Text('Start Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}