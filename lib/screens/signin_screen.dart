import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:financemanagement/reusable_widget/reusable_email_text_field.dart'; // Import the email widget
import 'package:financemanagement/reusable_widget/reusable_password_text_field.dart';

import '../reusable_widget/reusable_widget.dart'; // Import the password widget

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                SizedBox(height: 30),
                ReusableEmailTextField(
                  labelText: "Enter email",
                  icon: Icons.person_outline,
                  controller: emailController,
                ),
                SizedBox(height: 30),
                ReusablePasswordTextField(
                  labelText: "Enter password",
                  icon: Icons.lock_outline,
                  controller: passwordController,
                ),
                SizedBox(height: 30),
                signInButton(context, "Sign In", Colors.grey.shade300, () {
                  // Auto login logic
                  FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error: $error");
                  });
                }),
                SizedBox(height: 20),
                SignUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row SignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )],
    );
  }
}
