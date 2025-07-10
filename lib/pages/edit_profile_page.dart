import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late TextEditingController _firstNameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _languageController;
  late TextEditingController _locationController;
  late TextEditingController _pincodeController;
  late TextEditingController _bioController;
  late TextEditingController _maritalStatusController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _languageController = TextEditingController();
    _locationController = TextEditingController();
    _pincodeController = TextEditingController();
    _bioController = TextEditingController();
    _maritalStatusController = TextEditingController();
    _loadProfileData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _languageController.dispose();
    _locationController.dispose();
    _pincodeController.dispose();
    _bioController.dispose();
    _maritalStatusController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    try {
      final doc = await _firestore
          .collection('iot-matrimony')
          .doc('Users')
          .collection('Profile')
          .doc(widget.userId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = data['firstName'] ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _genderController.text = data['gender'] ?? '';
          _languageController.text = data['language'] ?? '';
          _locationController.text = data['location'] ?? '';
          _pincodeController.text = data['pincode']?.toString() ?? '';
          _bioController.text = data['bio'] ?? '';
          _maritalStatusController.text = data['maritalStatus'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore
            .collection('iot-matrimony')
            .doc('Users')
            .collection('Profile')
            .doc(widget.userId)
            .set({
          'firstName': _firstNameController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _genderController.text,
          'language': _languageController.text,
          'location': _locationController.text,
          'pincode': int.tryParse(_pincodeController.text) ?? 0,
          'bio': _bioController.text,
          'maritalStatus': _maritalStatusController.text,
          'photos': [], // Update this if photos are managed separately
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context); // Return to previous page
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter your first name' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty || int.tryParse(value) == null
                    ? 'Please enter a valid age'
                    : null,
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter your gender' : null,
              ),
              TextFormField(
                controller: _languageController,
                decoration: const InputDecoration(labelText: 'Language'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter your language' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter your location' : null,
              ),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(labelText: 'Pincode'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty || int.tryParse(value) == null
                    ? 'Please enter a valid pincode'
                    : null,
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a bio' : null,
              ),
              TextFormField(
                controller: _maritalStatusController,
                decoration: const InputDecoration(labelText: 'Marital Status'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter marital status' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}