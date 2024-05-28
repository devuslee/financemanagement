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

  void initState() {
    super.initState();
    calculateCategoryTotals(); // Load currency value from Firestore
  }

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

  void calculateCategoryTotals() {
    Map<String, int> categoryTotals = {}; // Map to store category totals

    // Get current user's ID
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch all transactions from Firestore
    FirebaseFirestore.instance.collection('Transaction').get().then((querySnapshot) {
      // Iterate through each transaction document
      querySnapshot.docs.forEach((doc) {
        String userId = doc['transactionUserID']; // Get user ID from transaction
        if (userId == currentUserId) {
          String category = doc['transactionCategory'];
          int amount = int.parse(doc['transactionAmount']);

          // Update category total in the map
          categoryTotals.update(category, (value) => value + amount, ifAbsent: () => amount);
        }
      });

      // Print category totals
      categoryTotals.forEach((category, total) {
        print('Category: $category, Total: $total');
      });
    }).catchError((error) {
      print('Error fetching transactions: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(_currentDate);
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];

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
                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Total Income: $totalIncome"),
                            Text("Total Expense: $totalExpense"),
                          ],
                        ),
                      ],
                    ),
                  );


                }
                ),
            SfCircularChart(
                series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper:(ChartData data,  _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    radius: '50%',
                  )
                ]
            )
          ],
        )
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
