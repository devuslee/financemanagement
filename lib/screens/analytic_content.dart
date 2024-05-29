
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
import 'dart:math' as math;

final List<ChartData> ExpenseChartData = [];
final List<ChartData> IncomeChartData = [];

List<String> chartTypeList = ["Expense", "Income"];
String chartType = chartTypeList.first;

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

    String month = monthNames[date.month - 1];
    String year = date.year.toString();

    return '$month $year';
  }

  void _incrementDate() {
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month + 1,
        _currentDate.day,
      );
      calculateCategoryTotals();
    });
  }

  void _decrementDate() {
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month - 1,
        _currentDate.day,
      );
      calculateCategoryTotals();
    });
  }

  void calculateCategoryTotals() {
    Map<String, int> ExpenseCategoryTotals = {};
    Map<String, int> IncomeCategoryTotals = {};

    // Get current user's ID
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch all transactions from Firestore
    FirebaseFirestore.instance.collection('Transaction').get().then((querySnapshot) {
      // Iterate through each transaction document
      for (var doc in querySnapshot.docs) {
        String userId = doc['transactionUserID'];
        DateTime transactionDateTime = DateTime.fromMillisecondsSinceEpoch(doc['transactionTime']);

        if (userId == currentUserId &&
            transactionDateTime.year == _currentDate.year &&
            transactionDateTime.month == _currentDate.month) {
          String category = doc['transactionCategory'];
          String type = doc['transactionType'];
          int amount = int.parse(doc['transactionAmount']);

          // Update category total in the map
          if (type == "Expense") {
            ExpenseCategoryTotals.update(
                category, (value) => value + amount, ifAbsent: () => amount);
          }
          if (type == "Income") {
            IncomeCategoryTotals.update(
                category, (value) => value + amount, ifAbsent: () => amount);
          }
        }
      }

      setState(() {
        ExpenseChartData.clear();
        IncomeChartData.clear();
        IncomeCategoryTotals.forEach((category, total) {
          IncomeChartData.add(ChartData(category, total.toDouble(), _getRandomColor()));
        });
        ExpenseCategoryTotals.forEach((category, total) {
          ExpenseChartData.add(ChartData(category, total.toDouble(), _getRandomColor()));
        });

      });
    }).catchError((error) {
      print('Error fetching transactions: $error');
    });
  }

  Color _getRandomColor() {
    return Color.fromRGBO(
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(_currentDate);

    return Scaffold(
        body: Padding(
        padding: const EdgeInsets.all(8.0),
    child: Column(
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
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: DropdownButton<String>(
    value: chartType,
    elevation: 16,
    style: const TextStyle(color: Colors.grey),
    onChanged: (String? newValue) {
    setState(() {
    chartType = newValue!;
    });
    },
    items: chartTypeList.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    ),
    ),
    Expanded(
    child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("Transaction").snapshots(),
    builder: (context, transactionSnapshot) {
    if (!transactionSnapshot.hasData) {
    return Center(child: CircularProgressIndicator());
    }

    final transactions = transactionSnapshot.data?.docs ?? [];

    transactions.sort((a, b) =>
    b["transactionTime"].compareTo(a["transactionTime"]));

    List<Row> transactionWidgets = [];

    for (var transaction in transactions) {
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
    transactionDateTime.month == _currentDate.month) {
    transactionWidgets.add(transactionWidget);
    }
    }

    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: chartType == "Expense" ? ExpenseChartData : IncomeChartData,
                          xValueMapper: (ChartData data, _) => data.name,
                          yValueMapper: (ChartData data, _) => data.value,
                          dataLabelMapper: (ChartData data, _) => '${data.name}: ${data.value}',
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            labelIntersectAction: LabelIntersectAction.none,
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          enableTooltip: true,
                        ),
                      ],
                    ),
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
                  if (chartType == "Income") {
                    for (var income in IncomeChartData) {
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
                          child: FutureBuilder<IconData>(
                            future: fetchCategoryIcon(income.name), // Call fetchCategoryIcon here
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // While waiting for the future to complete, return a placeholder or loading indicator
                                return CircularProgressIndicator(); // You can use any placeholder widget here
                              } else {
                                if (snapshot.hasError) {
                                  // If an error occurs while fetching the icon data, handle it here
                                  return Icon(Icons.error); // You can use any error indicator here
                                } else {
                                  // If the future completes successfully, use the returned IconData
                                  return Icon(
                                    snapshot.data, // Access IconData from snapshot.data
                                    size: 40,
                                    color: Colors.black,
                                  );
                                }
                              }
                            },
                          ),
                        ),

                        title: Text(
                              income.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              income.value.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green ,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  if (chartType == "Expense") {
                    for (var expense in ExpenseChartData) {
                      tiles.add(
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(
                                    0.3),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FutureBuilder<IconData>(
                                future: fetchCategoryIcon(expense.name), // Call fetchCategoryIcon here
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    // While waiting for the future to complete, return a placeholder or loading indicator
                                    return CircularProgressIndicator(); // You can use any placeholder widget here
                                  } else {
                                    if (snapshot.hasError) {
                                      // If an error occurs while fetching the icon data, handle it here
                                      return Icon(Icons.error); // You can use any error indicator here
                                    } else {
                                      // If the future completes successfully, use the returned IconData
                                      return Icon(
                                        snapshot.data, // Access IconData from snapshot.data
                                        size: 40,
                                        color: Colors.black,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),

                            title: Text(
                              expense.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              expense.value.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  return Column(
                    //if tiles empty return something else else
                    children: tiles.isEmpty
                        ? [

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(150),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center,
                            children: [
                              Image.asset(
                                height: 100,
                                width: 100,
                                "assets/images/empty_transaction.png", // Use any icon you prefer
                              ),
                              SizedBox(height: 20),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "No transactions found",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                        : tiles,
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

    ),
    ],
    ),
        ),
    );
  }
}

class ChartData {
  ChartData(this.name, this.value, [this.color]);
  final String name;
  final double value;
  final Color? color;
}

Future<IconData> fetchCategoryIcon(String categoryName) async {
  IconData tempIconName = Icons.category;

  DocumentSnapshot<Map<String, dynamic>> categoryDoc =
  await FirebaseFirestore.instance
      .collection("Categories")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  if (categoryDoc.exists) {
    String iconName = categoryDoc[categoryName];

    if (iconName == "Food") {
      tempIconName = Icons.fastfood;
    } else if (iconName == "Home") {
      tempIconName = Icons.home;
    } else if (iconName == "Person") {
      tempIconName = Icons.person;
    } else if (iconName == "Shopping") {
      tempIconName = Icons.shopping_cart;
    } else if (iconName == "Car") {
      tempIconName = Icons.car_rental;
    } else if (iconName == "Health") {
      tempIconName = Icons.health_and_safety;
    } else if (iconName == "Education") {
      tempIconName = Icons.book;
    } else if (iconName == "Entertainment") {
      tempIconName = Icons.movie;
    } else if (iconName == "Baby") {
      tempIconName = Icons.baby_changing_station;
    } else if (iconName == "Social") {
      tempIconName = Icons.event;
    }
  }

  return tempIconName;
}