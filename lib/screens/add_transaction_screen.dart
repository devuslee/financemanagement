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
import 'package:financemanagement/main.dart';
import 'package:flutter/widgets.dart';

bool isButtonEnabled = true;
int milidate = DateTime.now().millisecondsSinceEpoch;


class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

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

  final List<String> transactionTypeList = ["Income", "Expense"];
  final List<List<String>> transactionCategoryLists = [];
  int count = 0;

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String transactionTypeValue = "Income";

  String transactionCategoryValue = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

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

  Future<void> fetchCategories() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore
          .instance
          .collection('Categories')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();

        if (data != null) {
          List<List<String>> categories = [];
          data.forEach((key, value) {
            categories.add([key.toString(), value.toString()]);
          });

          categories.sort((a, b) =>
              a[0].compareTo(b[0])); //make sure the categories always display in the same manner

          setState(() {
            transactionCategoryLists.clear();
            transactionCategoryLists.addAll(categories);
            if (transactionCategoryLists.isNotEmpty) {
              transactionCategoryValue = transactionCategoryLists[0].first;
            }
          });
        }
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Failed to fetch categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(_currentDate);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
        backgroundColor: appbar,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Transaction",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              reusableTextField2(
                "Enter Transaction Name",
                Icons.person_outline,
                false,
                transactionName,
              ),
              SizedBox(height: 20),
              reusablePasswordField(
                "Enter Transaction Amount",
                Icons.attach_money,
                false,
                transactionAmount,
              ),
              SizedBox(height: 20),
              reusableTextField2(
                "Enter Transaction Description",
                Icons.description,
                false,
                transactionDescription,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Transaction Category",
                  border: OutlineInputBorder(),
                ),
                value: transactionCategoryValue,
                onChanged: (newValue) {
                  setState(() {
                    transactionCategoryValue = newValue!;
                  });
                },
                items: transactionCategoryLists
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value.first,
                    child: Text(value.first),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Transaction Type",
                  border: OutlineInputBorder(),
                ),
                value: transactionTypeValue,
                onChanged: (newValue) {
                  setState(() {
                    transactionTypeValue = newValue!;
                  });
                },
                items: transactionTypeList.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Transaction Time: $formattedDate",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025),
                      );
                      if (date != null) {
                        setState(() {
                          _currentDate = date;
                          milidate = date.millisecondsSinceEpoch;
                          duedateController.text = formatDate(date);
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (transactionName.text.isEmpty ||
              transactionAmount.text.isEmpty ||
              transactionDescription.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please fill in all the fields"),
              ),
            );
            return;
          }

          if (transactionAmount.text.contains(RegExp(r'[a-zA-Z]'))) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please enter a valid amount"),
              ),
            );
            return;
          }






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
            transactionCategory.clear();
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
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}