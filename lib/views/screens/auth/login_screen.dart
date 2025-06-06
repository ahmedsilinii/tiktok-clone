import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/constants/constants.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _onTapLogin() {
    // Handle login logic here
  }
  _onTapSignUp() {
    // Navigate to Sign Up screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Feed App')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextInputField(
                  labelText: 'Email',
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                TextInputField(
                  labelText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onTapLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: _onTapSignUp,
                      child:  Text(
                      'Sign Up',
                      style: TextStyle(color: AppColors.buttonColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
