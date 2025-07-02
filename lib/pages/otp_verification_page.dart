import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final VoidCallback onVerified;
  final Map<String, dynamic>? userData; // ✅ made optional

  const OTPVerificationPage({
    super.key,
    required this.verificationId,
    required this.onVerified,
    this.userData,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final otpController = TextEditingController();

  void _verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otpController.text,
    );

    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = userCredential.user?.uid;

      // 🔁 Save data only if userData is provided (i.e., during signup)
      if (uid != null && widget.userData != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set(widget.userData!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Login Successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );

      widget.onVerified();
    } catch (e) {
      print('🔥 FirebaseAuth Error → $e'); // Full raw error for debug

      String errorMsg = 'OTP verification failed.';

      if (e is FirebaseAuthException) {
        print('🔥 Code: ${e.code}, Message: ${e.message}');
        errorMsg = '❌ ${e.message ?? "OTP verification failed."}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
