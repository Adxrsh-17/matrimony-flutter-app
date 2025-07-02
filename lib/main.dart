import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // make sure this file exists



Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MatrimonyApp());
}

class MatrimonyApp extends StatefulWidget {
  const MatrimonyApp({super.key});

  @override
  State<MatrimonyApp> createState() => _MatrimonyAppState();
}

class _MatrimonyAppState extends State<MatrimonyApp> {
  bool _isLoggedIn = false;

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrimony App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: _isLoggedIn
          ? const HomePage()
          : LoginPage(onLogin: _handleLogin), // Start at LoginPage
    );
  }
}


