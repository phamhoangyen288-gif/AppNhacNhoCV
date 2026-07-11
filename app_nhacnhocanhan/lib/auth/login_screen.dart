import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text("Welcome Back!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text("Sign in to continue to Task Manager", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              _buildInput("Email", Icons.email_outlined),
              const SizedBox(height: 16),
              _buildInput("Enter your password", Icons.lock_outline, isPassword: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot'), child: const Text("Forgot Password?")),
              ),
              const SizedBox(height: 20),
              _buildButton("Login", () => Navigator.pushReplacementNamed(context, '/welcome')),
              const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("OR")),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/signup'), child: const Text("Don't have an account? Create Account")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: onPressed, child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}