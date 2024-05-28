import 'package:financemanagement/screens/analytic_content.dart';
import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/profile_content.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';
import 'package:financemanagement/main.dart';
import 'package:flutter/widgets.dart';


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
                reusableTextField("Enter email", Icons.person_outline, false, emailController),
                SizedBox(height: 30),
                reusableTextField("Enter password", Icons.lock_outline, true, passwordController),
                SizedBox(height: 30),
                reusableTextField("Enter confirm password", Icons.lock_outline, true, confirmpasswordController),
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold
            ),
          ),
        )],
    );
  }
}
