import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './global_user_data.dart'; // ✅ Add this import

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    if (GlobalUserCache.userData != null) {
      setState(() {
        userData = GlobalUserCache.userData;
        _loading = false;
      });
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userData = doc.data();
        GlobalUserCache.userData = userData;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("User data not found.")),
      );
    }

    String gender = userData?['gender'] ?? 'Male';
    String imageAsset = gender == 'Female'
        ? 'https://cdn-icons-png.flaticon.com/512/847/847969.png'
        : 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(imageAsset),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 24),
            _infoTile('Name', '${userData?['firstName']} ${userData?['lastName'] ?? ''}'),
            _infoTile('Father\'s Name', userData?['fatherName']),
            _infoTile('Email', userData?['email']),
            _infoTile('Age', userData?['age']?.toString()),
            _infoTile('Gender', userData?['gender']),
            _infoTile('Location', userData?['location']),
            _infoTile('Pincode', userData?['pincode']),
            _infoTile('Language', userData?['language']),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(value ?? '-', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
