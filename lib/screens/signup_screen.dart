import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financemanagement/reusable_widget/reusable_email_text_field.dart';
import 'package:financemanagement/reusable_widget/reusable_password_text_field.dart';

import '../reusable_widget/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
      Positioned.fill(
        child: Image.asset(
          'assets/images/moneymap.png',
          fit: BoxFit.cover,
        ),
      ),
        Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Create a Money Map Account", // New sentence added above the email column
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40), // Added spacing
                Form(
                  key: _formKey, // Assign form key
                  child: Column(
                    children: <Widget>[
                      ReusableEmailTextField(
                        labelText: "Enter email",
                        icon: Icons.person_outline,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email address';
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
                            return 'Password is required';
                          }
                          if (value.length < 8 ||
                              !value.contains(RegExp(r'[A-Z]')) ||
                              !value.contains(RegExp(r'[a-z]')) ||
                              !value.contains(RegExp(r'[0-9]')) ||
                              !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'Password must be at least 8 characters long and contain symbols, capital letters, and numbers';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ReusablePasswordTextField(
                        labelText: "Enter confirm password",
                        icon: Icons.lock_outline,
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is required';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      signInButton(context, "Sign Up", Colors.grey.shade300, () {
                        if (_formKey.currentState!.validate()) { // Validate the form
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                              .then((value) {
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .set({
                              "email": emailController.text,
                              "password": passwordController.text,
                              "userBudget": 0,
                              "userCurrency": "MYR",
                              "userDecimal": 0,
                              "userPosition": "Left",
                            }).then((value) {
                              FirebaseFirestore.instance
                                  .collection("ExpenseCategories")
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .set({
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
                                FirebaseFirestore.instance
                                    .collection("IncomeCategories")
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .set({
                                  'Salary': 'Salary',
                                  'Business': 'Business',
                                  'Gift': 'Gift',
                                  'Investment': 'Investment',
                                  'Loan': 'Loan',
                                }).then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                }).onError((error, stackTrace) {
                                  print("Error: $error");
                                  showErrorDialog(context, getErrorMessage(error));
                                });
                              }).onError((error, stackTrace) {
                                print("Error: $error");
                                showErrorDialog(context, getErrorMessage(error));
                              });
                            }).onError((error, stackTrace) {
                              print("Error: $error");
                              showErrorDialog(context, getErrorMessage(error));
                            });
                          }).onError((error, stackTrace) {
                            print("Error: $error");
                            showErrorDialog(context, getErrorMessage(error));
                          });
                        }
                      }),
                      SizedBox(height: 20),
                      SignUpOption(),
                      SizedBox(height: 100), // Added spacing to move the button and the sentence below it to the bottom
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          Positioned(
          top: 30, // Adjust the position as needed
    left: 10, // Adjust the position as needed
    child: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
    Navigator.pop(context);
    },
    ),
    ),
        ]
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          child: const Text(
            "Sign In",
            style:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  String getErrorMessage(dynamic error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is not strong enough.';
      default:
        return 'An undefined Error happened.';
    }
  }
}
