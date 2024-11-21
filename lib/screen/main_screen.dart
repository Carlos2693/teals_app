import 'package:flutter/material.dart';
import 'package:teals_app/widget/view/views.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(),
    );
  }
}
