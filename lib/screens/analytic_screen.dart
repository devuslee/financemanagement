import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/profile_screen.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';



class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int currentPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            if (index == 0) {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (index == 1) {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => AnalyticsScreen()),
              );
            } else if (index == 2) {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            }
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Profile',
          )

        ],
      ),
      body: Center(
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
              "Analytics Screen",
              style: TextStyle(fontSize: 20, color: Colors.black))
        ]),
      ),
    );
  }
}
