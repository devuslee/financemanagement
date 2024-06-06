import 'package:financemanagement/main.dart';
import 'package:financemanagement/screens/analytic_content.dart';
import 'package:financemanagement/screens/home_screen.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financemanagement/reusable_widget/reusable_widget.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:financemanagement/reusable_widget/IconWidget.dart';
import 'package:financemanagement/screens/update_password_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileScreenState();


}

class _ProfileScreenState extends State<ProfileContent> {
  String currencyvalue = "Loading...";
  int decimalvalue = 0;
  String positionvalue = "Loading...";
  int budgetvalue = 0;

  @override
  void initState() {
    super.initState();
    loadCurrencyValue(); // Load currency value from Firestore
  }

  void loadCurrencyValue() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          currencyvalue = userData["userCurrency"] ?? "MYR";
          decimalvalue = userData["userDecimal"] ?? 0;
          positionvalue = userData["userPosition"] ?? "Left";
          budgetvalue = userData["userBudget"] ?? 0;// Update currency value
        });
      }
    }
  }

  void updateUserCurrency(String currency) {
    // Get the current user's document reference
    DocumentReference userRef = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

    // Update the currency field in the document
    userRef.update({
      "userCurrency": currency,
    }).then((value) {
      print("Currency updated successfully");
      setState(() {
        currencyvalue = currency;
      });
    }).catchError((error) {
      print("Failed to update currency: $error");
    });
  }

  void updateUserDecimal(int decimal) {
    // Get the current user's document reference
    DocumentReference userRef = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

    // Update the currency field in the document
    userRef.update({
      "userDecimal": decimal,
    }).then((value) {
      print("Decimal place updated successfully");
      setState(() {
        decimalvalue = decimal;
      });
    }).catchError((error) {
      print("Failed to update currency: $error");
    });
  }

  void updateUserPosition(String position) {
    // Get the current user's document reference
    DocumentReference userRef = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

    // Update the currency field in the document
    userRef.update({
      "userPosition": position,
    }).then((value) {
      print("Decimal place updated successfully");
      setState(() {
        positionvalue = position;
      });
    }).catchError((error) {
      print("Failed to update currency: $error");
    });
  }

  void updateUserBudget(int budget) {
    // Get the current user's document reference
    DocumentReference userRef = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

    // Update the currency field in the document
    userRef.update({
      "userBudget": budget,
    }).then((value) {
      print("Decimal place updated successfully");
      setState(() {
        budgetvalue = budget;
      });
    }).catchError((error) {
      print("Failed to update currency: $error");
    });
  }

  int currentPageIndex = 2;
  @override
  Widget build(BuildContext context) {
    TextEditingController userBudgetController = TextEditingController();

    return Scaffold(
        body: SafeArea(
            child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  SettingsGroup(
                      title: "General",
                      children: <Widget>[

                        SimpleSettingsTile(
                            title: "Set your budget",
                            subtitle: budgetvalue.toString(),
                            leading: Icon(Icons.savings),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String userBudget = "0";
                                  return AlertDialog(
                                    title: Text('Enter Budget'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value) {
                                            userBudget = value; // Update the category name when input changes
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Set your budget',
                                          ),
                                          controller: userBudgetController,
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          int budget = int.parse(userBudget);
                                          updateUserBudget(budget);
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: Text('Done'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );

                            }
                        ),
                        SimpleSettingsTile(
                            title: "Currency Settings",
                            subtitle: currencyvalue,
                            leading: Icon(Icons.monetization_on),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Currency Settings"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Please choose an option:"),
                                          ListTile(
                                            title: Text("RM"),
                                            onTap: () {
                                              updateUserCurrency("RM");
                                              Navigator.pop(context); // Close the dialog
                                            },
                                          ),
                                          ListTile(
                                            title: Text("USD"),
                                            onTap: () {
                                              updateUserCurrency("\$");
                                              Navigator.pop(context); // Close the dialog
                                            },
                                          ),
                                          // Add more options as needed
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                            }
                        ),
                        SimpleSettingsTile(
                            title: "Currency position",
                            subtitle: positionvalue,
                            leading: Icon(Icons.currency_bitcoin),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Currency position"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Please choose an option:"),
                                          ListTile(
                                            title: Text("Left"),
                                            onTap: () {
                                              updateUserPosition("Left");
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text("Right"),
                                            onTap: () {
                                              updateUserPosition("Right");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                            }
                        ),
                        SimpleSettingsTile(
                            title: "Decimal places",
                            subtitle: decimalvalue.toString(),
                            leading: Icon(Icons.format_list_numbered),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Decimal places"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Please choose an option:"),
                                          ListTile(
                                            title: Text("0"),
                                            onTap: () {
                                              updateUserDecimal(0);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text("1"),
                                            onTap: () {
                                              updateUserDecimal(1);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text("2"),
                                            onTap: () {
                                              updateUserDecimal(2);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                            }
                        ),
                        SimpleSettingsTile(
                            title: "Change password",
                            subtitle: "Change your password",
                            leading: Icon(Icons.format_list_numbered),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => UpdatePasswordScreen()));
                            }
                        ),
                        SimpleSettingsTile(
                            title: "Logout",
                            subtitle: "English",
                            leading: Icon(Icons.language),
                            onTap: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SignInScreen()));
                              }).onError((error, stackTrace) {
                                print("Error: $error");
                              });
                            }
                        ),
                        SimpleSettingsTile(
                            title: "Delete Account",
                            subtitle: "Delete your account",
                            leading: Icon(Icons.delete),
                            onTap: () {
                              print("Country");
                            }
                        ),
                      ]
                  ),
                ],
              ),
          ),
    );
  }
}


