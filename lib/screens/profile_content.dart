import 'package:financemanagement/screens/analytic_content.dart';
import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentPageIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ElevatedButton(
              child: Text("Log Out"),
              onPressed: () {
                FirebaseAuth.instance.signOut()
                    .then((value) {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                }).onError((error, stackTrace) {
                  print("Error: $error");
                });
              },
            ),
              SizedBox(height: 20),
              Text(
                  "Profile Screen",
                  style: TextStyle(fontSize: 20, color: Colors.black))
            ]),
    );
  }
}
