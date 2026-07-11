import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text("Forgot Password?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Enter your email and we'll send you a link to reset your password.",
                  textAlign: TextAlign.center),
            ),

            // SỬA Ở ĐÂY: Dùng CustomTextField thay vì _buildInput
            const CustomTextField(
              hint: "Email",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 20),

            // SỬA Ở ĐÂY: Dùng ElevatedButton trực tiếp
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Logic gửi mail reset ở đây
                },
                child: const Text("Send Reset Link", style: TextStyle(fontSize: 16)),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}