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


const List<String> transactionTypeList = ["Income", "Expense"];

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController transactionName = TextEditingController();
  TextEditingController transactionAmount = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String dropdownValue = transactionTypeList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "Add Transaction",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      )
                    ),
                    Expanded(
                      flex: 2,
                        child: reusableTextField("Enter Transaction Name", Icons.person_outline, false, transactionName),
                    )],
                ),
                SizedBox(height: 30),
                reusableTextField("Enter Transaction Amount", Icons.lock_outline, false, transactionAmount),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 200, // Set width to screen width
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                        child: DropdownButton<String>
                          (value: dropdownValue,
                          elevation: 16,
                          style: const TextStyle(color: Colors.grey),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: transactionTypeList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                signInButton(context, "Add Transaction", Colors.blue, (){
                  CollectionReference collRef = FirebaseFirestore.instance.collection("Transaction");
                  collRef.add({
                    "transactionName": transactionName.text,
                    "transactionAmount": transactionAmount.text,
                    "transactionType": transactionType.text,
                    "transactionTime": timestamp
                  }).then((value) {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error: $error");
                  });

                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
