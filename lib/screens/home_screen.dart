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
                      final transactions = snapshot.data?.docs.toList();
                      transactions?.sort((a, b) => b["transactionTime"].compareTo(a["transactionTime"]));
                      for(var transaction in transactions!) {
                        final transactionName = transaction["transactionName"];
                        final transactionAmount = transaction["transactionAmount"];
                        final transactionType = transaction["transactionType"];
                        final transactionDescription = transaction["transactionDescription"];
                        String transactionCategory = "";

                        if (transaction["transactionCategory"] == "Food") {
                          transactionCategory = "food.png";
                        } else if (transaction["transactionCategory"] == "Transport") {
                          transactionCategory = "transport.png";
                        } else if (transaction["transactionCategory"] == "Shopping") {
                          transactionCategory = "shopping.png";
                        } else if (transaction["transactionCategory"] == "Others") {
                          transactionCategory = "others.png";
                        }
                        final transactionWidget = Row(
                          children: [
                            Text(transactionName),
                            Text(transactionAmount),
                            Text(transactionType),
                            Text(transactionCategory),
                            Text(transactionDescription),
                          ],
                        );
                        transactionWidgets.add(transactionWidget);

                      }
                    }
                    return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.all(8.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  List<Widget> tiles = [];

                                  for (var transactionWidget in transactionWidgets) {
                                    tiles.add(
                                      ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            "assets/images/${(((transactionWidget as Row).children[3] as Text).data ?? '')}",
                                          ),
                                        ),
                                        title: Text(
                                          //if empty it will print out null, PURELY FOR TESTING
                                          (((transactionWidget as Row).children[0] as Text).data ?? '').isEmpty
                                              ? 'Null'
                                              : ((transactionWidget as Row).children[0] as Text).data!,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          (((transactionWidget as Row).children[4] as Text).data ?? '').isEmpty
                                              ? 'Null'
                                              : ((transactionWidget as Row).children[4] as Text).data!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Text(
                                          (((transactionWidget as Row).children[1] as Text).data ?? '').isEmpty
                                              ? 'Null'
                                              : ((transactionWidget as Row).children[1] as Text).data!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: tiles,
                                  );
                                },
                                childCount: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            }
          ),
        ],
      ),
    ),
  ),
);
}
}

