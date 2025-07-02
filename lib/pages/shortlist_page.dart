import 'package:flutter/material.dart';

class ShortlistPage extends StatelessWidget {
  const ShortlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shortlisted Profiles')),
      body: const Center(child: Text('No profiles shortlisted yet.')),
    );
  }
}
