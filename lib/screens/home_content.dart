import 'package:financemanagement/screens/add_transaction_screen.dart';
import 'package:financemanagement/screens/analytic_content.dart';
import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/profile_content.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/screens/update_transaction_screen.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:financemanagement/main.dart';

int userBudget = 0;
bool budgetSurpasses = false;

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  DateTime _currentDate = DateTime.now();
  final dateFormat = DateFormat('yyyy-MM-dd');

  String formatDate(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
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
              stream: FirebaseFirestore.instance
                  .collection("Transaction")
                  .snapshots(),
              builder: (context, transactionSnapshot) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("IncomeCategories")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, IncomecategoriesSnapshot) {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("ExpenseCategories")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, ExpensecategoriesSnapshot) {
                            List<Row> transactionWidgets = [];
                            int totalIncome = 0;
                            int totalMonthExpense = 0;
                            int totalMonthIncome = 0;
                            int totalExpense = 0;
                            String userCurrency = "";

                            int userDecimal = 0;
                            String userPosition = "";
                            String userCategory = "";

                            if (userSnapshot.hasData) {
                              final tempuserCurrency =
                                  userSnapshot.data?.get("userCurrency");
                              final tempuserBudget =
                                  userSnapshot.data?.get("userBudget");
                              final tempuserDecimal =
                                  userSnapshot.data?.get("userDecimal");
                              final tempuserPosition =
                                  userSnapshot.data?.get("userPosition");

                              userCurrency = tempuserCurrency;
                              userBudget = tempuserBudget;
                              userDecimal = tempuserDecimal;
                              userPosition = tempuserPosition;
                            }

                            if (transactionSnapshot.hasData) {
                              final transactions =
                                  transactionSnapshot.data?.docs.toList();
                              transactions?.sort((a, b) => b["transactionTime"]
                                  .compareTo(a["transactionTime"]));
                              for (var transaction in transactions!) {
                                final transactionName =
                                    transaction["transactionName"];
                                final transactionAmount =
                                    transaction["transactionAmount"];
                                final transactionType =
                                    transaction["transactionType"];
                                final transactionDescription =
                                    transaction["transactionDescription"];
                                IconData transactionCategory = Icons.category;
                                final transactionUserID =
                                    transaction["transactionUserID"];
                                final transactionTime =
                                    transaction["transactionTime"];
                                final transactionID =
                                    transaction["transactionID"];

                                if (transactionUserID ==
                                    FirebaseAuth.instance.currentUser!.uid) {
                                  DateTime transactionDateTime =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          transactionTime);

                                  if (transactionType == "Income") {
                                    if (IncomecategoriesSnapshot.hasData) {
                                      String tempcategories =
                                          IncomecategoriesSnapshot.data?.get(
                                              transaction[
                                                  "transactionCategory"]);

                                      userCategory = tempcategories;
                                    }
                                  } else {
                                    if (ExpensecategoriesSnapshot.hasData) {
                                      String tempcategories =
                                          ExpensecategoriesSnapshot.data?.get(
                                              transaction[
                                                  "transactionCategory"]);

                                      userCategory = tempcategories;
                                    }
                                  }

                                  if (userCategory == "Food") {
                                    transactionCategory = Icons.fastfood;
                                  } else if (userCategory == "Home") {
                                    transactionCategory = Icons.home;
                                  } else if (userCategory == "Person") {
                                    transactionCategory = Icons.person;
                                  } else if (userCategory == "Shopping") {
                                    transactionCategory = Icons.shopping_cart;
                                  } else if (userCategory == "Car") {
                                    transactionCategory = Icons.car_rental;
                                  } else if (userCategory == "Health") {
                                    transactionCategory =
                                        Icons.health_and_safety;
                                  } else if (userCategory == "Education") {
                                    transactionCategory = Icons.book;
                                  } else if (userCategory == "Entertainment") {
                                    transactionCategory = Icons.movie;
                                  } else if (userCategory == "Baby") {
                                    transactionCategory =
                                        Icons.baby_changing_station;
                                  } else if (userCategory == "Social") {
                                    transactionCategory = Icons.event;
                                  } else if (userCategory == "Salary") {
                                    transactionCategory = Icons.money;
                                  } else if (userCategory == "Business") {
                                    transactionCategory = Icons.business;
                                  } else if (userCategory == "Gift") {
                                    transactionCategory = Icons.card_giftcard;
                                  } else if (userCategory == "Investment") {
                                    transactionCategory = Icons.attach_money;
                                  } else if (userCategory == "Loan") {
                                    transactionCategory = Icons.money_off;
                                  }

                                  final transactionWidget = Row(
                                    children: [
                                      Text(transactionName),
                                      Text(transactionAmount),
                                      Text(transactionType),
                                      Text(transactionCategory.codePoint
                                          .toString()),
                                      Text(transactionDescription),
                                      Text(userCategory),
                                      Text(transactionID),
                                      Text(transactionTime.toString()),
                                    ],
                                  );
                                  if (transactionUserID ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid &&
                                      transactionDateTime.year ==
                                          _currentDate.year &&
                                      transactionDateTime.month ==
                                          _currentDate.month &&
                                      transactionDateTime.day ==
                                          _currentDate.day) {
                                    transactionWidgets.add(transactionWidget);
                                    if (transactionType == "Income") {
                                      totalIncome +=
                                          int.parse(transactionAmount);
                                    } else {
                                      totalExpense +=
                                          int.parse(transactionAmount);
                                    }
                                  }

                                  if (transactionUserID ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid &&
                                      transactionDateTime.year ==
                                          _currentDate.year &&
                                      transactionDateTime.month ==
                                          _currentDate.month) {
                                    if (transactionType == "Income") {
                                      totalMonthIncome +=
                                          int.parse(transactionAmount);
                                    } else {
                                      totalMonthExpense +=
                                          int.parse(transactionAmount);
                                    }
                                  }

                                  if (totalMonthExpense > userBudget) {
                                    budgetSurpasses = true;
                                  } else {
                                    budgetSurpasses = false;
                                  }
                                }
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Expenses",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              "Income",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              "Balance",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              formatCurrency(
                                                  totalExpense,
                                                  userCurrency ?? "MYR",
                                                  userPosition ?? "left",
                                                  userDecimal ?? 2),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              formatCurrency(
                                                  totalIncome,
                                                  userCurrency ?? "MYR",
                                                  userPosition ?? "left",
                                                  userDecimal ?? 2),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              formatCurrency(
                                                  totalIncome - totalExpense,
                                                  userCurrency ?? "MYR",
                                                  userPosition ?? "left",
                                                  userDecimal ?? 2),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: totalIncome -
                                                            totalExpense >
                                                        0
                                                    ? Colors.green
                                                    : totalIncome -
                                                                totalExpense <
                                                            0
                                                        ? Colors.red
                                                        : Colors.grey,
                                              ),
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

                                          for (var transactionWidget
                                              in transactionWidgets) {
                                            tiles.add(
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: ListTile(
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Icon(
                                                      IconData(
                                                        int.parse(((transactionWidget
                                                                        as Row)
                                                                    .children[3]
                                                                as Text)
                                                            .data!),
                                                        fontFamily:
                                                            'MaterialIcons',
                                                      ),
                                                      size: 40,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  title: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                "Transaction Details",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    "Name: ${((transactionWidget as Row).children[0] as Text).data ?? 'Null'}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        "Amount: ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "${formatCurrency(
                                                                          int.tryParse(((transactionWidget as Row).children[1] as Text).data ?? '') ??
                                                                              0,
                                                                          userCurrency ??
                                                                              "MYR",
                                                                          userPosition ??
                                                                              "left",
                                                                          userDecimal ??
                                                                              2,
                                                                        )}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: ((transactionWidget as Row).children[2] as Text).data == 'Income'
                                                                              ? Colors.green
                                                                              : Colors.red,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    "Type: ${((transactionWidget as Row).children[2] as Text).data ?? 'Null'}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Category: ${((transactionWidget as Row).children[5] as Text).data ?? 'Null'}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Description: ${((transactionWidget as Row).children[4] as Text).data ?? 'Null'}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();

                                                                      var currentUser = FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid;

                                                                      Query<Map<String, dynamic>> transactionQuery = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "Transaction")
                                                                          .where(
                                                                              'transactionCategory',
                                                                              isEqualTo: ((transactionWidget as Row).children[5] as Text)
                                                                                  .data)
                                                                          .where(
                                                                              'transactionName',
                                                                              isEqualTo: ((transactionWidget as Row).children[0] as Text)
                                                                                  .data)
                                                                          .where(
                                                                              'transactionAmount',
                                                                              isEqualTo: ((transactionWidget as Row).children[1] as Text)
                                                                                  .data)
                                                                          .where(
                                                                              'transactionType',
                                                                              isEqualTo: ((transactionWidget as Row).children[2] as Text).data)
                                                                          .where('transactionDescription', isEqualTo: ((transactionWidget as Row).children[4] as Text).data)
                                                                          .where('transactionUserID', isEqualTo: currentUser);

                                                                      // Fetch and delete all transactions associated with the category
                                                                      QuerySnapshot<
                                                                              Map<String, dynamic>>
                                                                          transactionSnapshot =
                                                                          await transactionQuery
                                                                              .get();
                                                                      for (var doc
                                                                          in transactionSnapshot
                                                                              .docs) {
                                                                        await doc
                                                                            .reference
                                                                            .delete();
                                                                      }
                                                                    } catch (e) {
                                                                      // Handle any errors
                                                                      print(
                                                                          "Failed to delete category: $e");
                                                                      // Optionally, show an alert dialog to inform the user of the error
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text("Error"),
                                                                            content:
                                                                                Text("Failed to delete category: $e"),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text("OK"),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red)),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                      return UpdateTransaction(
                                                                        transactionID: ((transactionWidget as Row).children[6] as Text).data ?? '',
                                                                        transactionName: ((transactionWidget as Row).children[0] as Text).data ?? '',
                                                                        transactionAmount: ((transactionWidget as Row).children[1] as Text).data ?? '',
                                                                        transactionType: ((transactionWidget as Row).children[2] as Text).data ?? '',
                                                                        transactionCategory: ((transactionWidget as Row).children[5] as Text).data ?? '',
                                                                        transactionDescription: ((transactionWidget as Row).children[4] as Text).data ?? '',
                                                                        transactionTime: ((transactionWidget as Row).children[7] as Text).data ?? '',
                                                                      );
                                                                    }));
                                                                  },
                                                                  child: Text(
                                                                    "Edit",
                                                                    style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    "Close",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      (((transactionWidget as Row)
                                                                              .children[0]
                                                                          as Text)
                                                                      .data ??
                                                                  '')
                                                              .isEmpty
                                                          ? 'Null'
                                                          : ((transactionWidget
                                                                          as Row)
                                                                      .children[
                                                                  0] as Text)
                                                              .data!,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    (((transactionWidget as Row)
                                                                            .children[4]
                                                                        as Text)
                                                                    .data ??
                                                                '')
                                                            .isEmpty
                                                        ? 'Null'
                                                        : ((transactionWidget
                                                                        as Row)
                                                                    .children[4]
                                                                as Text)
                                                            .data!,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    formatCurrency(
                                                      int.tryParse(((transactionWidget
                                                                              as Row)
                                                                          .children[
                                                                      1] as Text)
                                                                  .data ??
                                                              '') ??
                                                          0,
                                                      userCurrency ?? "MYR",
                                                      userPosition ?? "left",
                                                      userDecimal ?? 2,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ((transactionWidget
                                                                              as Row)
                                                                          .children[
                                                                      2] as Text)
                                                                  .data ==
                                                              'Income'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          return Column(
                                            //if tiles empty show an empty transaction icon
                                            children: tiles.isEmpty
                                                ? [
                                                    Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            60.0), // Reduced padding for mobile responsiveness
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/empty_transaction.png",
                                                              height: 100,
                                                              width: 100,
                                                            ),
                                                            SizedBox(
                                                                height: 20),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  "No transactions found",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
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
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String formatCurrency(
    int amount, String currency, String position, int decimalPoints) {
  // Format the amount based on currency, position, and decimal points
  NumberFormat currencyFormatter = NumberFormat.currency(
    symbol: currency,
    decimalDigits: decimalPoints,
  );

  String formattedAmount = currencyFormatter.format(amount.toDouble());

  // Adjust position if necessary
  if (position.toLowerCase() == "right") {
    formattedAmount = formattedAmount.replaceAll("${currency}", "") + currency;
  }

  return formattedAmount;
}

String fetchCategoryIcon(String categoryName) {
  String tempIconName = "";

  Future<DocumentSnapshot<Map<String, dynamic>>> categoryRef = FirebaseFirestore
      .instance
      .collection("Categories")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  // Fetch the category document
  categoryRef.then((categoryDoc) {
    if (categoryDoc.exists) {
      String iconName = categoryDoc[categoryName];
      // Get the icon name based on the category name
      tempIconName = iconName;
    }
  });
  return tempIconName;
}
