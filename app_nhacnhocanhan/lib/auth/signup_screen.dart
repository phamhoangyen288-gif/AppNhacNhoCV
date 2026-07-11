import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Join us and start managing your tasks"),
            const SizedBox(height: 30),

            // Thay thế _buildInput bằng CustomTextField
            const CustomTextField(hint: "Full Name", icon: Icons.person_outline),
            const SizedBox(height: 16),
            const CustomTextField(hint: "Email", icon: Icons.email_outlined),
            const SizedBox(height: 16),
            const CustomTextField(hint: "Create a password", icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 16),
            const CustomTextField(hint: "Confirm your password", icon: Icons.lock_outline, isPassword: true),

            const SizedBox(height: 20),

            // Thay thế _buildButton bằng cấu trúc Button trực tiếp
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
                  // Logic đăng ký tại đây
                },
                child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}