import 'package:flutter/material.dart';

class ProfileListPage extends StatelessWidget {
  const ProfileListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile List')),
      body: const Center(child: Text('Profile List Page')),
    );
  }
}
