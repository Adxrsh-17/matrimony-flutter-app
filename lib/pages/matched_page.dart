import 'package:flutter/material.dart';
import 'user_profile.dart';

class MatchedPage extends StatefulWidget {
  final Function(Map<String, dynamic>) shortlistCallback;
  final List<Map<String, dynamic>> shortlistedUsers;

  const MatchedPage({super.key, required this.shortlistCallback, required this.shortlistedUsers});

  @override
  State<MatchedPage> createState() => _MatchedPageState();
}

class _MatchedPageState extends State<MatchedPage> {
  final List<Map<String, dynamic>> dummyUsers = [
    {'name': 'Priya Sharma', 'age': 22, 'profession': 'Designer', 'interests': ['UI/UX', 'Drawing'], 'image': 'https://i.pravatar.cc/150?img=1'},
    {'name': 'Ravi Kumar', 'age': 23, 'profession': 'Developer', 'interests': ['AI', 'Photography'], 'image': 'https://i.pravatar.cc/150?img=2'},
    {'name': 'Sneha Reddy', 'age': 21, 'profession': 'Writer', 'interests': ['Reading', 'Storytelling'], 'image': 'https://i.pravatar.cc/150?img=3'},
    {'name': 'Vikram Das', 'age': 24, 'profession': 'Developer', 'interests': ['UI/UX', 'Tech'], 'image': 'https://i.pravatar.cc/150?img=4'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: dummyUsers.length,
      itemBuilder: (context, index) {
        final user = dummyUsers[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(radius: 40, backgroundImage: NetworkImage(user['image'])),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Age: ${user['age']}'),
                        Text('Profession: ${user['profession']}'),
                        const SizedBox(height: 4),
                        Text('Interests: ${user['interests'].join(', ')}', style: const TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.pink),
                    onPressed: () => widget.shortlistCallback(user),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}