import 'dart:async';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 7), () { // Duration of the splash screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/moneymap.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Centered fading text
          Center(
            child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'MoneyMap',
                  textStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  duration: Duration(seconds: 5), // Duration of fade-in effect
                ),
              ],
              totalRepeatCount: 1, // Ensure it only runs once
            ),
          ),
        ],
      ),
    );
  }
}


