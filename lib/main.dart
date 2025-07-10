import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/landingPage.dart';
import 'pages/user_profile.dart';
import 'pages/register_page.dart';
import 'pages/shortlist_page.dart';
import 'pages/chat_page.dart'; // ✅ Chat import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MatrimonyApp());
}

class MatrimonyApp extends StatelessWidget {
  const MatrimonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrimony App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/landing': (context) => const LandingPage(),
        '/profile': (context) => const UserProfilePage(),
        '/register': (context) => const RegisterPage(),
        '/shortlist': (context) => const ShortlistPage(),
        // ✅ Add Chat Dashboard route
        '/chatDashboard': (context) => ChatDashboard(
          currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
        ),
      },
    );
  }
}
