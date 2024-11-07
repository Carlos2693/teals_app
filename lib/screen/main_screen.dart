import 'package:flutter/material.dart';

import 'package:teals_app/widget/view/views.dart';

class MainScreen extends StatelessWidget {

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashView(logoPath: 'assets/images/logo.png'),
    );
  }
}


