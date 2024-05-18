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
import 'package:financemanagement/main.dart';

bool isButtonEnabled = true;
int milidate = DateTime.now().millisecondsSinceEpoch;

const List<String> transactionTypeList = ["Income", "Expense"];
const List<String> transactionCategoryList = [
  "Food",
  "Transport",
  "Shopping",
  "Others"
];

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController transactionName = TextEditingController();
  TextEditingController transactionAmount = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController transactionCategory = TextEditingController();
  TextEditingController transactionDescription = TextEditingController();
  TextEditingController duedateController = TextEditingController();

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String transactionTypeValue = transactionTypeList.first;
  String transactionCategoryValue = transactionCategoryList.first;

  DateTime _currentDate = DateTime.now();

  // Function to format the date manually
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

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(_currentDate);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Add Transaction: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: reusableTextField(
                          "Enter Transaction Name",
                          Icons.person_outline,
                          false,
                          transactionName,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Transaction Amount: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: reusableTextField(
                          "Enter Transaction Amount",
                          Icons.lock_outline,
                          false,
                          transactionAmount,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Transaction Description: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: reusableTextField(
                          "Enter Transaction Description",
                          Icons.lock_outline,
                          false,
                          transactionDescription,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Transaction Category: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 200, // Set width to screen width
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButton<String>(
                            value: transactionCategoryValue,
                            elevation: 16,
                            style: const TextStyle(color: Colors.grey),
                            onChanged: (String? newValue) {
                              setState(() {
                                transactionCategoryValue = newValue!;
                              });
                            },
                            items: transactionCategoryList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Transaction Type: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 200, // Set width to screen width
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButton<String>(
                            value: transactionTypeValue,
                            elevation: 16,
                            style: const TextStyle(color: Colors.grey),
                            onChanged: (String? newValue) {
                              setState(() {
                                transactionTypeValue = newValue!;
                              });
                            },
                            items: transactionTypeList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Transaction Time: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          readOnly: true  ,
                        decoration: InputDecoration(
                          hintText: formattedDate,
                        ),
                        controller: duedateController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(onPressed: () async{
                          DateTime? date=await
                          showDatePicker(context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025)
                          );
                          milidate = date!.millisecondsSinceEpoch;
                          duedateController.text= formatDate(date!);
                        },icon: const Icon(Icons.calendar_today)),
                      ),
                    ],
                  ),
                  signInButton(context, "Add Transaction", Colors.blue, () {

                    CollectionReference collRef =
                        FirebaseFirestore.instance.collection("Transaction");
                    collRef.add({
                      "transactionName": transactionName.text,
                      "transactionAmount": transactionAmount.text,
                      "transactionType": transactionTypeValue,
                      "transactionCategory": transactionCategoryValue,
                      "transactionDescription": transactionDescription.text,
                      "transactionTime": milidate,
                      "transactionUserID": globalUID
                    }).then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }).onError((error, stackTrace) {
                      print("Error: $error");
                    }).whenComplete(() {
                      setState(() {
                        // Re-enable the button after transaction is complete or failed
                        isButtonEnabled = true;
                      });
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

