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
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/moneymap.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Sign-in form
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      logoWidget("assets/images/logo.png"),
                      SizedBox(height: 30),
                      ReusableEmailTextField(
                        labelText: "Enter email",
                        icon: Icons.person_outline,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill in your email';
                          }
                          // Using a basic email regex for validation
                          String pattern =
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'Incorrect email format';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ReusablePasswordTextField(
                        labelText: "Enter password",
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill in your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      signInButton(context, "Sign In", Colors.grey.shade300, () {
                        if (_formKey.currentState!.validate()) {
                          // Clear the previous error message
                          setState(() {
                            errorMessage = '';
                          });

                          // Auto login logic
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                              .then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          }).onError((error, stackTrace) {
                            String errorCode = (error as FirebaseAuthException).code;
                            switch (errorCode) {
                              case 'user-not-found':
                                setState(() {
                                  errorMessage = 'Account not found. Please sign up.';
                                });
                                break;
                              case 'wrong-password':
                                setState(() {
                                  errorMessage = 'Incorrect password. Please try again.';
                                });
                                break;
                              case 'invalid-email':
                                setState(() {
                                  errorMessage = 'Incorrect email format.';
                                });
                                break;
                              default:
                                setState(() {
                                  errorMessage = 'An error occurred. Please try again.';
                                });
                            }
                          });
                        }
                      }),
                      SizedBox(height: 20),
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      SignUpOption(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
