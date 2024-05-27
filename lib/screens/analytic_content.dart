import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/profile_content.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';



class AnalyticsContent extends StatefulWidget {
  const AnalyticsContent({super.key});

  @override
  State<AnalyticsContent> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsContent> {
  int currentPageIndex = 1;
  DateTime _currentDate = DateTime.now();
  final dateFormat = DateFormat('yyyy-MM-dd');

  String formatDate(DateTime date) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    String day = date.day.toString();
    String month = monthNames[date.month - 1];
    String year = date.year.toString();

    return '$day, $month $year';
  }

  void _incrementDate() {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: 1));
    });
  }

  void _decrementDate() {
    setState(() {
      _currentDate = _currentDate.subtract(Duration(days: 1));
    });
  }
  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(_currentDate);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Transaction").snapshots(),
                builder: (context, transactionSnapshot) {
                  List<Row> transactionWidgets = [];
                  int totalIncome = 0;
                  int totalExpense = 0;
                  String userCurrency = "";
                  int userBudget = 0;
                  int userDecimal = 0;
                  String userPosition = "";

                  if (transactionSnapshot.hasData) {
                    final transactions = transactionSnapshot.data?.docs
                        .toList();
                    transactions?.sort((a, b) =>
                        b["transactionTime"].compareTo(a["transactionTime"]));
                    for (var transaction in transactions!) {
                      final transactionName = transaction["transactionName"];
                      final transactionAmount = transaction["transactionAmount"];
                      final transactionType = transaction["transactionType"];
                      final transactionDescription = transaction["transactionDescription"];
                      String transactionCategory = "";
                      final transactionUserID = transaction["transactionUserID"];
                      final transactionTime = transaction["transactionTime"];

                      DateTime transactionDateTime = DateTime
                          .fromMillisecondsSinceEpoch(transactionTime);

                      if (transaction["transactionCategory"] == "Food") {
                        transactionCategory = "food.png";
                      } else
                      if (transaction["transactionCategory"] == "Transport") {
                        transactionCategory = "transport.png";
                      } else
                      if (transaction["transactionCategory"] == "Shopping") {
                        transactionCategory = "shopping.png";
                      } else
                      if (transaction["transactionCategory"] == "Others") {
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
                      if (transactionUserID ==
                          FirebaseAuth.instance.currentUser!.uid &&
                          transactionDateTime.month == _currentDate.month) {
                        transactionWidgets.add(transactionWidget);
                        if (transactionType == "Income") {
                          totalIncome += int.parse(transactionAmount);
                        } else {
                          totalExpense += int.parse(transactionAmount);
                        }
                      }
                    }
                  }
                  return Expanded(child: Text("Total Income: $totalIncome\nTotal Expense: $totalExpense"));
                }
                )
          ],
        )
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}


