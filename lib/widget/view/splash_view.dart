import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {

  static const int _favorWidthScreen = 2;

  final String logoPath;
  final Color colorDarkMode;
  final Color colorLigthMode;

  const SplashView({
    super.key,
    required this.logoPath,
    this.colorDarkMode = Colors.black,
    this.colorLigthMode = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          color: isDarkMode ? Colors.black : Colors.white,
        ),
        SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  logoPath,
                  width: size.width / _favorWidthScreen,
                ),
                Text(
                  "Teals",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 55,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}