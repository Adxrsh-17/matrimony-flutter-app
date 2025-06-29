import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile.dart';

class ProfileListPage extends StatelessWidget {
  const ProfileListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profilesRef = FirebaseFirestore.instance.collection('profiles');

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Profiles"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: profilesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final profiles = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              return UserProfileCard(user: profiles[index]);
            },
          );
        },
      ),
    );
  }
}
