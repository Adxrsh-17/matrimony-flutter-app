import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

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

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'fatherName': fatherNameController.text,
          'email': emailController.text,
          'age': int.tryParse(ageController.text),
          'gender': selectedGender,
          'location': locationController.text,
          'pincode': pincodeController.text,
          'language': languageController.text,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Registration Successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Registration failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matrimony Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field('First Name', firstNameController, validator: _validateName),
              _field('Last Name (Optional)', lastNameController, required: false),
              _field('Father\'s Name', fatherNameController, validator: _validateName),
              _field('Email', emailController, type: TextInputType.emailAddress, validator: _validateEmail),
              _field('Password', passwordController, type: TextInputType.visiblePassword, validator: _validatePassword),
              _field('Age', ageController, type: TextInputType.number, validator: _validateAge),
              _genderDropdown(),
              _field('Location', locationController, validator: _validateAlphaOnly),
              _field('Pincode', pincodeController, type: TextInputType.number, validator: _validatePincode),
              _field('Language', languageController, validator: _validateAlphaOnly),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register'),
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
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
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
        decoration: const InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // === VALIDATORS ===

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
