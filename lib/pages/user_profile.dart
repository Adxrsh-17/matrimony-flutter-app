import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  final pincodeController = TextEditingController();
  final languageController = TextEditingController();
  String gender = 'Male';
  String email = '';
  List<String> photoUrls = [];
  String? profileImageUrl;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('iot-matrimony')
        .doc('Users')
        .collection('Profile')
        .doc(uid)
        .get();

    final data = doc.data();
    if (data != null) {
      firstNameController.text = data['firstName'] ?? '';
      lastNameController.text = data['lastName'] ?? '';
      fatherNameController.text = data['fatherName'] ?? '';
      ageController.text = data['age']?.toString() ?? '';
      locationController.text = data['location'] ?? '';
      pincodeController.text = data['pincode'] ?? '';
      languageController.text = data['language'] ?? '';
      gender = data['gender'] ?? 'Male';
      email = data['email'] ?? '';
      photoUrls = List<String>.from(data['photos'] ?? []);
      profileImageUrl = data['profileImageUrl'];
    }

    setState(() => _loading = false);
  }

  Future<void> _uploadImage() async {
    if (photoUrls.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 4 images allowed')),
      );
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    final file = File(picked.path);
    if (await file.length() > 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image must be less than 1MB')),
      );
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
    )
      ..fields['fileName'] = 'profile_${DateTime.now().millisecondsSinceEpoch}'
      ..fields['publicKey'] = 'public_h+DukCXF+vw23bsUrE3vJJYwLxY='
      ..files.add(await http.MultipartFile.fromPath('file', picked.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final url = RegExp(r'"url":"(.*?)"').firstMatch(body)?.group(1);
      if (url != null) {
        setState(() => photoUrls.add(url));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Image upload failed')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('iot-matrimony')
        .doc('Users')
        .collection('Profile')
        .doc(uid)
        .update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'fatherName': fatherNameController.text,
      'age': int.tryParse(ageController.text),
      'location': locationController.text,
      'pincode': pincodeController.text,
      'language': languageController.text,
      'photos': photoUrls,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  profileImageUrl?.isNotEmpty == true
                      ? profileImageUrl!
                      : gender == 'Female'
                      ? 'https://cdn-icons-png.flaticon.com/512/847/847969.png'
                      : 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                ),
              ),
              const SizedBox(height: 24),
              _editableField('First Name', firstNameController),
              _editableField('Last Name', lastNameController, required: false),
              _editableField('Father\'s Name', fatherNameController),
              _staticField('Email', email),
              _staticField('Gender', gender),
              _editableField('Age', ageController, type: TextInputType.number),
              _editableField('Location', locationController),
              _editableField('Pincode', pincodeController, type: TextInputType.number),
              _editableField('Language', languageController),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Photos', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo, color: Colors.deepPurple),
                    onPressed: _uploadImage,
                  )
                ],
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(4, (index) {
                  if (index < photoUrls.length) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(photoUrls[index], width: 80, height: 80, fit: BoxFit.cover),
                    );
                  } else {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_outlined, size: 32),
                    );
                  }
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (val) => val == null || val.isEmpty ? 'Enter $label' : null
            : null,
      ),
    );
  }

  Widget _staticField(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: Text('$label: $value', style: const TextStyle(fontSize: 16)),
    );
  }
}
