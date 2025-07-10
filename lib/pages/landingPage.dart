import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_list_page.dart';
import 'shortlist_page.dart';
import 'user_profile.dart';
import 'chat_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> titles = [
    "Welcome",
    "Browse Profiles",
    "Shortlist",
    "My Profile",
    "Chat",
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const WelcomeContent(),
      const ProfileListPage(),
      const ShortlistPage(),
      const UserProfilePage(),
      ChatDashboard(currentUserId: FirebaseAuth.instance.currentUser!.uid),
    ];
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

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "Matrimony - Find Your Better Half",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF8E24AA),
        elevation: 6,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF4A148C), const Color(0xFF8E24AA)],
            ),
          ),
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF6A1B9A),
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Opacity(
                        opacity: _animation.value,
                        child: const Text(
                          '👤 Welcome User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: titles.length + 1, // +1 for the logout option
                  itemBuilder: (context, index) {
                    if (index == titles.length) {
                      return ListTile(
                        leading: const Icon(Icons.logout, color: Colors.white),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pop(context); // Close the drawer
                          // Optionally navigate to a login screen
                          // Navigator.pushReplacementNamed(context, '/login');
                        },
                      );
                    }
                    final isSelected = _selectedIndex == index;
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ListTile(
                        leading: Icon(
                          _getIcon(index),
                          color: isSelected ? Colors.amber : Colors.white,
                        ),
                        title: Text(
                          titles[index],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.amber : Colors.white,
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onTap: () {
                          _navigateTo(index);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _getUnreadChatCountStream(),
        initialData: 0,
        builder: (context, snapshot) {
          final unreadCount = snapshot.data ?? 0;
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateTo,
            backgroundColor: const Color(0xFF6A1B9A),
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: List.generate(titles.length, (index) {
              return BottomNavigationBarItem(
                icon: index == 4
                    ? AnimatedChatIcon(
                  isSelected: _selectedIndex == 4,
                  unreadCount: unreadCount,
                )
                    : Icon(_getIcon(index)),
                label: titles[index],
              );
            }),
            elevation: 10,
            selectedIconTheme: const IconThemeData(size: 28),
            unselectedIconTheme: const IconThemeData(size: 24),
          );
        },
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.people;
      case 2:
        return Icons.favorite;
      case 3:
        return Icons.person;
      case 4:
        return Icons.chat_bubble_outline; // Updated to match enhanced chat icon
      default:
        return Icons.home;
    }
  }

  Stream<int> _getUnreadChatCountStream() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('iot-matrimony')
        .doc('Users')
        .collection('Profile')
        .doc(currentUserId)
        .snapshots()
        .asyncMap((profileSnapshot) async {
      final data = profileSnapshot.data() as Map<String, dynamic>? ?? {};
      final chatBoxes = List<String>.from(data['chatBoxes'] ?? []);
      if (chatBoxes.isEmpty) return 0;

      final futures = chatBoxes.map((boxId) => FirebaseFirestore.instance
          .collection('iot-matrimony')
          .doc('Users')
          .collection('messageBox')
          .doc(boxId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUserId)
          .get());

      final snapshots = await Future.wait(futures);
      int totalUnread = 0;
      for (var snap in snapshots) {
        totalUnread += snap.docs.length;
      }
      return totalUnread;
    }).asBroadcastStream();
  }
}

// New Widget for Enhanced Chat Icon
class AnimatedChatIcon extends StatefulWidget {
  final bool isSelected;
  final int unreadCount;

  const AnimatedChatIcon({
    super.key,
    required this.isSelected,
    required this.unreadCount,
  });

  @override
  State<AnimatedChatIcon> createState() => _AnimatedChatIconState();
}

class _AnimatedChatIconState extends State<AnimatedChatIcon> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.unreadCount > 0) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedChatIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.unreadCount > 0 && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (widget.unreadCount == 0 && _animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Chat with your matches',
      child: Stack(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              Icons.chat_bubble_outline,
              color: widget.isSelected ? Colors.amber : Colors.white70,
              size: widget.isSelected ? 28 : 24,
            ),
          ),
          if (widget.unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.pinkAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  widget.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background_image.jpg',
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Matrimony App',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: const Offset(3, 3),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Text(
                  'Where Hearts Meet, Matches are Made',
                  style: GoogleFonts.caveat(
                    fontSize: 26,
                    color: Colors.pinkAccent[100],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 45),
                Text(
                  'Find your perfect life partner\nwith trust, values, and love.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to profile or next screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent[100],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}