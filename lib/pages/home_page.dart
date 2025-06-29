import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'shortlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> dummyUsers = [
    {
      'name': 'Priya Sharma',
      'age': 22,
      'profession': 'Designer',
      'interests': ['UI/UX', 'Drawing'],
      'image': 'assets/images/girl_cartoon.png',
      'isLocal': true
    },
    {
      'name': 'Ravi Kumar',
      'age': 23,
      'profession': 'Developer',
      'interests': ['AI', 'Photography'],
      'image': 'https://i.pravatar.cc/150?img=2',
      'isLocal': false
    },
    {
      'name': 'Sneha Reddy',
      'age': 21,
      'profession': 'Writer',
      'interests': ['Reading', 'Storytelling'],
      'image': 'assets/images/woman_face.png',
      'isLocal': true
    },
    {
      'name': 'Vikram Das',
      'age': 24,
      'profession': 'Developer',
      'interests': ['UI/UX', 'Tech'],
      'image': 'https://i.pravatar.cc/150?img=4',
      'isLocal': false
    },
  ];

  final List<Map<String, dynamic>> shortlistedUsers = [];

  void _shortlistUser(Map<String, dynamic> user) {
    if (!shortlistedUsers.contains(user)) {
      setState(() {
        shortlistedUsers.add(user);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Shortlisted ${user['name']}!')),
      );
    }
  }

  void _navigateToShortlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShortlistPage(shortlistedUsers: shortlistedUsers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matched Profiles'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'View Shortlist',
            onPressed: _navigateToShortlist,
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyUsers.length,
        itemBuilder: (context, index) {
          final user = dummyUsers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: user),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user['isLocal']
                          ? AssetImage(user['image']) as ImageProvider
                          : NetworkImage(user['image']),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Age: ${user['age']}'),
                          Text('Profession: ${user['profession']}'),
                          const SizedBox(height: 4),
                          Text(
                            'Interests: ${user['interests'].join(', ')}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.pink),
                      onPressed: () => _shortlistUser(user),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
