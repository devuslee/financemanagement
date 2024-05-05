import 'package:financemanagement/screens/add_transaction_screen.dart';
import 'package:financemanagement/screens/analytic_screen.dart';
import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/profile_screen.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddTransactionScreen()));
                  },
                  child: Text("+"),
                ),
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Transaction").snapshots(),
                    builder: (context, snapshot) {
                    List<Row> transactionWidgets = [];

                    if(snapshot.hasData) {
                      final transactions = snapshot.data?.docs.reversed.toList();
                      for(var transaction in transactions!) {
                        final transactionName = transaction["transactionName"];
                        final transactionAmount = transaction["transactionAmount"];
                        final transactionType = transaction["transactionType"];

                        final transactionWidget = Row(
                          children: [
                            Text(transactionName),
                            Text(transactionAmount),
                            Text(transactionType)
                          ],
                        );
                        transactionWidgets.add(transactionWidget);
                      }
                    }
                    return Expanded(
                      child: ListView(
                        children: <Widget>[
                          for (var transactionWidget in transactionWidgets)
                            Container(
                              height: 100,
                              color: Colors.amber[600],
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (transactionWidget as Row).children[0].toString(), // Accessing transactionName
                                        textAlign: TextAlign.left, // Adjust as needed
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (transactionWidget as Row).children[1].toString(), // Accessing transactionAmount
                                          textAlign: TextAlign.center, // Adjust as needed
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          (transactionWidget as Row).children[2].toString(), // Accessing transactionType
                                          textAlign: TextAlign.right, // Adjust as needed
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                  ), // Accessing transactionType
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
