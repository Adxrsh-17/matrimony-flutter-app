import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'landingPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  final pincodeController = TextEditingController();
  final languageController = TextEditingController();
  String selectedGender = 'Male';

  File? _selectedImage;
  String? _uploadedImageUrl;

  Future<void> _pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;

    _selectedImage = File(picked.path);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.imgbb.com/1/upload'),
    )
      ..fields['key'] = '1cca605f6e52fd853fcc704c1eaf99a1'
      ..files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final data = json.decode(body);
      final url = data['data']['url'];
      if (url != null) {
        setState(() => _uploadedImageUrl = url);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Image uploaded successfully')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Image upload failed')));
    }
  }

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('iot-matrimony')
            .doc('Users')
            .collection('Profile')
            .doc(uid)
            .set({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'fatherName': fatherNameController.text,
          'email': emailController.text,
          'age': int.tryParse(ageController.text),
          'gender': selectedGender,
          'location': locationController.text,
          'pincode': pincodeController.text,
          'language': languageController.text,
          'photos': _uploadedImageUrl != null ? [_uploadedImageUrl] : [],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Registration Successful')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LandingPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Registration failed: ${e.toString()}')),
      );
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
        title: const Text('Matrimony - Find Your Better Half', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E24AA), Color(0xFF4A148C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.favorite, size: 60, color: Color(0xFF8E24AA)),
              const Text(
                'Create Your Matrimonial Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A148C)),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field('First Name', firstNameController, prefixIcon: Icons.person, validator: _validateName),
                    _field('Last Name (Optional)', lastNameController, required: false, prefixIcon: Icons.person_outline),
                    _field('Father\'s Name', fatherNameController, prefixIcon: Icons.family_restroom, validator: _validateName),
                    _field('Email', emailController, type: TextInputType.emailAddress, prefixIcon: Icons.email, validator: _validateEmail),
                    _field('Password', passwordController, type: TextInputType.visiblePassword, prefixIcon: Icons.lock, validator: _validatePassword),
                    _field('Age', ageController, type: TextInputType.number, prefixIcon: Icons.cake, validator: _validateAge),
                    _genderDropdown(),
                    _field('Location', locationController, prefixIcon: Icons.location_on, validator: _validateAlphaOnly),
                    _field('Pincode', pincodeController, type: TextInputType.number, prefixIcon: Icons.pin_drop, validator: _validatePincode),
                    _field('Language', languageController, prefixIcon: Icons.language, validator: _validateAlphaOnly),
                    const SizedBox(height: 12),
                    if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty)
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _uploadedImageUrl!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: _pickAndUploadImage,
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8E24AA)),
                      child: const Text('Upload Profile Image', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4A148C)),
                      child: const Text('Find Your Soulmate', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        TextInputType type = TextInputType.text,
        bool required = true,
        String? Function(String?)? validator,
        IconData? prefixIcon,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Color(0xFF8E24AA)) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
        obscureText: label == 'Password',
        validator: required
            ? validator ?? (val) => val == null || val.isEmpty ? 'Enter $label' : null
            : null,
      ),
    );
  }

  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        onChanged: (value) => setState(() => selectedGender = value!),
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: const Icon(Icons.wc, color: Color(0xFF8E24AA)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Field is required';
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) return 'Only letters and spaces allowed';
    return null;
  }

  String? _validateAlphaOnly(String? value) {
    if (value == null || value.isEmpty) return 'Field is required';
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value)) return 'Only letters and spaces allowed';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    if (age == null || age < 21 || age > 100) {
      return 'Age must be between 21 and 100';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) return 'Pincode is required';
    final pincodeRegex = RegExp(r'^\d{6}$');
    if (!pincodeRegex.hasMatch(value)) return 'Enter valid 6-digit pincode';
    return null;
  }
}