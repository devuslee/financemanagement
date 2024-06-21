import 'package:flutter/material.dart';
import 'package:financemanagement/screens/add_transaction_screen.dart';
import 'package:financemanagement/screens/analytic_content.dart';
import 'package:financemanagement/screens/home_content.dart';
import 'package:financemanagement/screens/category_content.dart';
import 'package:financemanagement/screens/profile_content.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';
import 'package:financemanagement/reusable_widget/custom_bottom_nav_bar.dart';

import '../main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    AnalyticsContent(),
    CategoryContent(),
    ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // This allows the body to extend behind the bottom navigation bar
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/moneymap.png',
            fit: BoxFit.cover,
          ),
          // Page content
          Positioned.fill(
            child: Column(
              children: [
                if (currentPageIndex == 0)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                  ),
                Expanded(
                  child: _pages[currentPageIndex],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          if (budgetSurpasses == true) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Warning"),
                  content: Text("You have surpassed your budget!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTransactionScreen(),
                          ),
                        );
                      },
                      child: Text("Continue"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                );
              },
            );
          } else
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => AddTransactionScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
