import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email and password cannot be empty.');
      return;
    }

    try {
      _toggleLoading(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _showSnackBar('Login successful!');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _showSnackBar('No user found for that email.');
          break;
        case 'wrong-password':
          _showSnackBar('Wrong password provided.');
          break;
        case 'invalid-email':
          _showSnackBar('The email address is not valid.');
          break;
        default:
          _showSnackBar(e.message ?? 'An error occurred during login.');
      }
    } finally {
      _toggleLoading(false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Please enter your email.');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackBar('Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _showSnackBar('No user found for that email.');
          break;
        case 'invalid-email':
          _showSnackBar('The email address is not valid.');
          break;
        default:
          _showSnackBar(e.message ?? 'Failed to send password reset email.');
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _showSnackBar('Google sign-in canceled.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _showSnackBar('Google sign-in successful!');
    } catch (e) {
      _showSnackBar('Failed to sign in with Google: ${e.toString()}');
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);
      _showSnackBar('Apple sign-in successful!');
    } catch (e) {
      _showSnackBar('Failed to sign in with Apple: ${e.toString()}');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else ...[
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _buildButton(text: 'Login', onPressed: _login),
              _buildButton(text: 'Reset Password', onPressed: _resetPassword),
              const Divider(height: 40, thickness: 1),
              _buildButton(
                  text: 'Login with Google', onPressed: _signInWithGoogle),
              if (Platform.isIOS)
                // Only show Apple sign-in on iOS devices
                _buildButton(
                    text: 'Login with Apple', onPressed: _signInWithApple),
            ],
          ],
        ),
      ),
    );
  }
}
