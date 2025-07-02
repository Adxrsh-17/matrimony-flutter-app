import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'otp_verification_page.dart';

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
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  final pincodeController = TextEditingController();
  final languageController = TextEditingController();
  String selectedGender = 'Male';

  void _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = phoneController.text;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) {},
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP failed: ${e.message}')),
        );
      },
      codeSent: (verificationId, resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationPage(
              verificationId: verificationId,
              userData: {
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'fatherName': fatherNameController.text,
                'email': emailController.text,
                'phone': phone,
                'age': int.tryParse(ageController.text),
                'gender': selectedGender,
                'location': locationController.text,
                'pincode': pincodeController.text,
                'language': languageController.text,
              },
              onVerified: () {},
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
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
              _field('First Name', firstNameController),
              _field('Last Name', lastNameController),
              _field('Father\'s Name', fatherNameController),
              _field('Email', emailController, type: TextInputType.emailAddress),
              _field('Phone (+91...)', phoneController, type: TextInputType.phone),
              _field('Age', ageController, type: TextInputType.number),
              _genderDropdown(),
              _field('Location', locationController),
              _field('Pincode', pincodeController, type: TextInputType.number),
              _field('Language', languageController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendOTP,
                child: const Text('Register & Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
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
}
