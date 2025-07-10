import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔁 Create or Fetch Chat Box
Future<String> getOrCreateChatBox(
    String currentUserId,
    String otherUserId,
    ) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final result = await firestore
        .collection('iot-matrimony')
        .doc('Users')
        .collection('messageBox')
        .where('participants', arrayContains: currentUserId)
        .get();

    for (var doc in result.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }

    final newBox = await firestore
        .collection('iot-matrimony')
        .doc('Users')
        .collection('messageBox')
        .add({
      'participants': [currentUserId, otherUserId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    for (String id in [currentUserId, otherUserId]) {
      await firestore
          .collection('iot-matrimony')
          .doc('Users')
          .collection('Profile')
          .doc(id)
          .set({
        'chatBoxes': FieldValue.arrayUnion([newBox.id])
      }, SetOptions(merge: true));
    }

    return newBox.id;
  } catch (e) {
    print('Error creating chat box: $e');
    return '';
  }
}

/// 💬 Chat Page with other user’s name in AppBar
class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String chatBoxId;

  const ChatPage({
    super.key,
    required this.currentUserId,
    required this.chatBoxId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  String? otherUserName;

  @override
  void initState() {
    super.initState();
    _loadOtherUserName();
    _markMessagesAsRead();
  }

  Future<void> _loadOtherUserName() async {
    try {
      final boxSnap = await firestore
          .collection('iot-matrimony')
          .doc('Users')
          .collection('messageBox')
          .doc(widget.chatBoxId)
          .get();

      final participants = List<String>.from(boxSnap['participants']);
      final otherUserId = participants.firstWhere(
            (id) => id != widget.currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isNotEmpty) {
        final profileSnap = await firestore
            .collection('iot-matrimony')
            .doc('Users')
            .collection('Profile')
            .doc(otherUserId)
            .get();

        setState(() {
          otherUserName = profileSnap['firstName'] ?? 'User';
        });
      }
    } catch (e) {
      print('Error loading other user name: $e');
    }
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final unreadMessages = await firestore
          .collection('iot-matrimony')
          .doc('Users')
          .collection('messageBox')
          .doc(widget.chatBoxId)
          .collection('messages')
          .where('senderId', isNotEqualTo: widget.currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      await firestore
          .collection('iot-matrimony')
          .doc('Users')
          .collection('messageBox')
          .doc(widget.chatBoxId)
          .collection('messages')
          .add({
        'senderId': widget.currentUserId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      _controller.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageRef = firestore
        .collection('iot-matrimony')
        .doc('Users')
        .collection('messageBox')
        .doc(widget.chatBoxId)
        .collection('messages')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserName ?? 'Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messageRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg =
                    docs[index].data() as Map<String, dynamic>;
                    final isMe =
                        msg['senderId'] == widget.currentUserId;
                    return Container(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🧭 Chat Dashboard with enhanced UI
class ChatDashboard extends StatefulWidget {
  final String currentUserId;

  const ChatDashboard({super.key, required this.currentUserId});

  @override
  State<ChatDashboard> createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard> {
  final TextEditingController inputController = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<void> startChatWithUser(String profileName) async {
    if (profileName.isEmpty) return;

    try {
      final userQuery = await firestore
          .collection('iot-matrimony')
          .doc('Users')
          .collection('Profile')
          .where('firstName', isEqualTo: profileName)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with name: $profileName')),
        );
        return;
      }

      final otherUserId = userQuery.docs.first.id;
      final chatBoxId =
      await getOrCreateChatBox(widget.currentUserId, otherUserId);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(
            currentUserId: widget.currentUserId,
            chatBoxId: chatBoxId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting chat: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Your Soulmate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFF8A2BE2)], // Gold to Purple
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9E6), Color(0xFFDDA0DD)], // Light Gold to Plum
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: inputController,
                          decoration: InputDecoration(
                            labelText: 'Search Tamil Nadu Matches',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.purple),
                        onPressed: () => startChatWithUser(inputController.text.trim()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('iot-matrimony')
                    .doc('Users')
                    .collection('Profile')
                    .doc(widget.currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                  final chatBoxes = List<String>.from(data['chatBoxes'] ?? []);

                  if (chatBoxes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No soulmates yet. Explore & Connect! 💞',
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.purple),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: chatBoxes.length,
                    itemBuilder: (context, index) {
                      final boxId = chatBoxes[index];

                      return FutureBuilder<DocumentSnapshot>(
                        future: firestore
                            .collection('iot-matrimony')
                            .doc('Users')
                            .collection('messageBox')
                            .doc(boxId)
                            .get(),
                        builder: (context, boxSnap) {
                          if (boxSnap.connectionState == ConnectionState.waiting) {
                            return const Card(
                              child: ListTile(title: Text('Loading...')),
                            );
                          }
                          if (boxSnap.hasError || !boxSnap.hasData) {
                            return const Card(
                              child: ListTile(title: Text('Error loading chat')),
                            );
                          }

                          final participants = List<String>.from(boxSnap.data!['participants']);
                          final otherUserId = participants.firstWhere(
                                  (id) => id != widget.currentUserId,
                              orElse: () => '');

                          if (otherUserId.isEmpty) return const SizedBox();

                          return FutureBuilder<DocumentSnapshot>(
                            future: firestore
                                .collection('iot-matrimony')
                                .doc('Users')
                                .collection('Profile')
                                .doc(otherUserId)
                                .get(),
                            builder: (context, profSnap) {
                              if (profSnap.connectionState == ConnectionState.waiting) {
                                return const Card(
                                  child: ListTile(title: Text('Loading...')),
                                );
                              }
                              if (profSnap.hasError || !profSnap.hasData) {
                                return const Card(
                                  child: ListTile(title: Text('Unknown User')),
                                );
                              }

                              final profData = profSnap.data!.data() as Map<String, dynamic>? ?? {};
                              final profileName = profData['firstName'] ?? 'Unknown';

                              return FutureBuilder<QuerySnapshot>(
                                future: firestore
                                    .collection('iot-matrimony')
                                    .doc('Users')
                                    .collection('messageBox')
                                    .doc(boxId)
                                    .collection('messages')
                                    .where('isRead', isEqualTo: false)
                                    .where('senderId', isNotEqualTo: widget.currentUserId)
                                    .get(),
                                builder: (context, unreadSnap) {
                                  final unreadCount = unreadSnap.data?.docs.length ?? 0;

                                  return Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: Colors.white.withOpacity(0.95),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      leading: const Icon(Icons.favorite, color: Colors.pink, size: 28),
                                      title: Text(
                                        profileName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.purple,
                                        ),
                                      ),
                                      trailing: unreadCount > 0
                                          ? Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                          : const Icon(Icons.chat_bubble_outline, color: Colors.blueGrey, size: 24),
                                      onTap: () async {
                                        final chatBoxId = await getOrCreateChatBox(widget.currentUserId, otherUserId);
                                        if (!mounted) return;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ChatPage(
                                              currentUserId: widget.currentUserId,
                                              chatBoxId: chatBoxId,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}