import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onSave;

  const EditProfilePage({super.key, required this.user, required this.onSave});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController professionController;
  late TextEditingController interestsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    ageController = TextEditingController(text: widget.user['age'].toString());
    professionController = TextEditingController(text: widget.user['profession']);
    interestsController = TextEditingController(text: widget.user['interests'].join(', '));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
            TextField(controller: professionController, decoration: const InputDecoration(labelText: 'Profession')),
            TextField(controller: interestsController, decoration: const InputDecoration(labelText: 'Interests (comma-separated)')),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              onPressed: () {
                final updatedUser = {
                  'name': nameController.text,
                  'age': int.tryParse(ageController.text) ?? 0,
                  'profession': professionController.text,
                  'interests': interestsController.text.split(',').map((e) => e.trim()).toList(),
                  'image': widget.user['image'],
                };
                widget.onSave(updatedUser);
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
