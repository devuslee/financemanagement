import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financemanagement/reusable_widget/reusable_email_text_field.dart'; // Import the email widget
import 'package:financemanagement/reusable_widget/reusable_password_text_field.dart';

import '../reusable_widget/reusable_widget.dart'; // Import the password widget

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

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
                ReusablePasswordTextField(
                  labelText: "Enter confirm password",
                  icon: Icons.lock_outline,
                  controller: confirmpasswordController,
                ),
                SizedBox(height: 30),
                signInButton(context, "Sign Up", Colors.grey.shade300, () {
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text)
                      .then((value) {
                    FirebaseFirestore.instance.collection("Users").doc(
                        FirebaseAuth.instance.currentUser?.uid).set({
                      "email": emailController.text,
                      "password": passwordController.text,
                      "userBudget": 0,
                      "userCurrency": "MYR",
                      "userDecimal": 0,
                      "userPosition": "Left",
                    }).then((value) {
                      FirebaseFirestore.instance.collection("Categories").doc(
                          FirebaseAuth.instance.currentUser?.uid).set({
                        'Food': "Food",
                        'Home': 'Home',
                        'Person': 'Person',
                        'Shopping': 'Shopping',
                        'Car': 'Car',
                        'Health': 'Health',
                        'Education': 'Education',
                        'Entertainment': 'Entertainment',
                        'Baby': 'Baby',
                        'Social': 'Social',
                      }).then((value) {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }).onError((error, stackTrace) {
                        print("Error: $error");
                      });
                    }).onError((error, stackTrace) {
                      print("Error: $error");
                    });
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
          "Already have an account? ",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          child: const Text(
            "Sign In",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )],
    );
  }
}
