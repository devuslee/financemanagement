import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';

bool isButtonEnabled = true;
int milidate = DateTime.now().millisecondsSinceEpoch;

class UpdateTransaction extends StatefulWidget {
  String transactionID;
  String transactionName;
  String transactionAmount;
  String transactionType;
  String transactionCategory;
  String transactionDescription;
  String transactionTime;

  UpdateTransaction({
    Key? key,
    required this.transactionID,
    required this.transactionName,
    required this.transactionAmount,
    required this.transactionType,
    required this.transactionCategory,
    required this.transactionDescription,
    required this.transactionTime,
  }) : super(key: key);

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  TextEditingController transactionName = TextEditingController();
  TextEditingController transactionAmount = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController transactionCategory = TextEditingController();
  TextEditingController transactionDescription = TextEditingController();
  TextEditingController duedateController = TextEditingController();

  List<List<String>> IncometransactionCategoryLists = [["Loading...", "Loading"]];
  List<List<String>> ExpensetransactionCategoryLists = [["Loading...", "Loading"]];
  final List<String> transactionTypeList = ["Income", "Expense"];
  bool isLoading = true; // Track the loading state

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String transactionCategoryValue = "Loading...";
  String transactionTypeValue = "Income"; // Default value, can be modified later

  @override
  void initState() {
    super.initState();
    fetchCategories();
    transactionName.text = widget.transactionName;
    transactionAmount.text = widget.transactionAmount;
    transactionType.text = widget.transactionType;
    transactionCategory.text = widget.transactionCategory;
    transactionDescription.text = widget.transactionDescription;

    // Set initial values
    transactionCategoryValue = widget.transactionCategory;
    transactionTypeValue = widget.transactionType;
  }
  //i need to set _currentDate to the date of the transaction



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
      DocumentSnapshot<Map<String, dynamic>> IncomedocumentSnapshot = await FirebaseFirestore.instance
          .collection('IncomeCategories')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      DocumentSnapshot<Map<String, dynamic>> ExpensedocumentSnapshot = await FirebaseFirestore.instance
          .collection('ExpenseCategories')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (ExpensedocumentSnapshot.exists) {
        Map<String, dynamic>? data = ExpensedocumentSnapshot.data();

        if (data != null) {
          List<List<String>> Expensecategories = [];
          data.forEach((key, value) {
            Expensecategories.add([key.toString(), value.toString()]);
          });

          Expensecategories.sort((a, b) => a[0].compareTo(b[0])); //make sure the categories always display in the same manner

          setState(() {
            ExpensetransactionCategoryLists.clear();
            ExpensetransactionCategoryLists.addAll(Expensecategories);
          });
        }
      } else {
        print("Document does not exist");
      }

      if (IncomedocumentSnapshot.exists) {
        Map<String, dynamic>? data = IncomedocumentSnapshot.data();

        if (data != null) {
          List<List<String>> Incomecategories = [];
          data.forEach((key, value) {
            Incomecategories.add([key.toString(), value.toString()]);
          });

          Incomecategories.sort((a, b) => a[0].compareTo(b[0])); //make sure the categories always display in the same manner

          setState(() {
            IncometransactionCategoryLists.clear();
            IncometransactionCategoryLists.addAll(Incomecategories);
          });
        }
      } else {
        print("Document does not exist");
      }

      // Ensure the transactionCategoryValue is correctly set after fetching categories
      setState(() {
        if (transactionTypeValue == "Income") {
          transactionCategoryValue = IncometransactionCategoryLists
              .firstWhere((category) => category[0] == widget.transactionCategory, orElse: () => IncometransactionCategoryLists[0])
              .first;
        } else {
          transactionCategoryValue = ExpensetransactionCategoryLists
              .firstWhere((category) => category[0] == widget.transactionCategory, orElse: () => ExpensetransactionCategoryLists[0])
              .first;
        }
        isLoading = false; // Set loading to false after categories are fetched
      });

    } catch (e) {
      print("Failed to fetch categories: $e");
      setState(() {
        isLoading = false; // Set loading to false even if there is an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime _currentDate = DateTime.fromMillisecondsSinceEpoch(int.parse(widget.transactionTime));
    String formattedDate = formatDate(_currentDate);

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Transaction"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/moneymap.png',
              fit: BoxFit.cover,
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator()) // Display loading indicator while fetching categories
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Update Transaction",
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
                    items: transactionTypeValue == "Income"
                        ? IncometransactionCategoryLists.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.first,
                        child: Text(value.first),
                      );
                    }).toList()
                        : ExpensetransactionCategoryLists.map<DropdownMenuItem<String>>((value) {
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
                        transactionCategoryValue = transactionTypeValue == "Income"
                            ? IncometransactionCategoryLists.first.first
                            : ExpensetransactionCategoryLists.first.first;
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
                          "Transaction Time: ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _currentDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2025),
                          );
                          if (date != null) {
                            setState(() {
                              _currentDate = date;
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
        ],
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

          CollectionReference collRef = FirebaseFirestore.instance.collection("Transaction");
          collRef.doc(widget.transactionID).update({
            "transactionName": transactionName.text,
            "transactionAmount": transactionAmount.text,
            "transactionType": transactionTypeValue,
            "transactionCategory": transactionCategoryValue,
            "transactionDescription": transactionDescription.text,
            "transactionTime": _currentDate.millisecondsSinceEpoch,
            "transactionUserID": FirebaseAuth.instance.currentUser?.uid,
            "transactionID": widget.transactionID,
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
        child: const Icon(Icons.save),
      ),
    );
  }
}
