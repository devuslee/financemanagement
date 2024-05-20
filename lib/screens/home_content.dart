import 'package:financemanagement/screens/add_transaction_screen.dart';
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
import 'package:intl/intl.dart';
import 'package:financemanagement/main.dart';


class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decrementDate,
                  icon: Icon(
                    Icons.arrow_left,
                    size: 50,
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _incrementDate,
                  icon: Icon(
                    Icons.arrow_right,
                    size: 50,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Transaction").snapshots(),
              builder: (context, snapshot) {
                List<Row> transactionWidgets = [];
                int totalIncome = 0;
                int totalExpense = 0;

                if (snapshot.hasData) {
                  final transactions = snapshot.data?.docs.toList();
                  transactions?.sort((a, b) => b["transactionTime"].compareTo(a["transactionTime"]));
                  for (var transaction in transactions!) {
                    final transactionName = transaction["transactionName"];
                    final transactionAmount = transaction["transactionAmount"];
                    final transactionType = transaction["transactionType"];
                    final transactionDescription = transaction["transactionDescription"];
                    String transactionCategory = "";
                    final transactionUserID = transaction["transactionUserID"];
                    final transactionTime = transaction["transactionTime"];

                    DateTime transactionDateTime = DateTime.fromMillisecondsSinceEpoch(transactionTime);

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
                    if (transactionUserID == FirebaseAuth.instance.currentUser!.uid &&
                        transactionDateTime.year == _currentDate.year &&
                        transactionDateTime.month == _currentDate.month &&
                        transactionDateTime.day == _currentDate.day) {
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
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total Expenses: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "\$${totalExpense}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Total Income: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "\$${totalIncome}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Total Balance: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "\$${totalIncome - totalExpense}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: totalIncome - totalExpense > 0
                                          ? Colors.green
                                          : totalIncome - totalExpense < 0
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              List<Widget> tiles = [];

                              for (var transactionWidget in transactionWidgets) {
                                tiles.add(
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.3),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          "assets/images/${(((transactionWidget as Row).children[3] as Text).data ?? '')}",
                                        ),
                                      ),
                                      title: Text(
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
                                            : ((transactionWidget as Row).children[2] as Text).data == 'Expense'
                                            ? "-" + ((transactionWidget as Row).children[1] as Text).data!
                                            : ((transactionWidget as Row).children[1] as Text).data!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: ((transactionWidget as Row).children[2] as Text).data == 'Income'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}