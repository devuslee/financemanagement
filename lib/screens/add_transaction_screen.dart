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
      DocumentSnapshot<
          Map<String, dynamic>> documentSnapshot = await FirebaseFirestore
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
            print(categories);
          });

          categories.sort((a, b) =>
              a[0].compareTo(
                  b[0])); //make sure the categories always display in the same manner


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

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
        backgroundColor: appbar,
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
                            fontSize: 14,
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
                            fontSize: 10,
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
                            fontSize: 10,
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
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 200, // Set width to screen width
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButton<String>(
                            padding: EdgeInsets.all(10),
                            hint: Text("Loading..."),
                            value: transactionCategoryValue,
                            elevation: 16,
                            style: const TextStyle(color: Colors.grey),
                            onChanged: (String? newValue) {
                              setState(() {
                                transactionCategoryValue = newValue!;
                              });
                            },
                            items: transactionCategoryLists
                                .map<DropdownMenuItem<String>>((List<String> value) {
                              return DropdownMenuItem<String>(
                                  value: value.first,
                                  child: Text(value.first));
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(width: 10),
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
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 200, // Set width to screen width
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButton<String>(
                            padding: EdgeInsets.all(10),
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
                      Expanded(
                        flex: 1,
                        child: SizedBox(width: 10),
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
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
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
                        child: SizedBox(width: 10),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
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
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
              DocumentReference docRef =
                  FirebaseFirestore.instance.collection("Categories").doc(globalUID);

              DocumentSnapshot docSnapshot = await docRef.get();

              if (docSnapshot.exists) {
                transactionCategoryValue = docSnapshot['${transactionCategoryValue}'];
                if (transactionCategoryValue != null) {
                  // Use the transactionCategoryValue here
                  print("Transaction Category Value: $transactionCategoryValue");
                } else {
                  print("Transaction Category Value is null or does not exist.");
                }
              } else {
                print("Document does not exist.");
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

