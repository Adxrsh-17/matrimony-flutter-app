import 'package:flutter/material.dart';

class MatchedPage extends StatelessWidget {
  const MatchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: const Center(child: Text('Matched Page')),
    );
  }
}
