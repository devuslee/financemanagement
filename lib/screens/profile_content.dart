import 'package:financemanagement/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financemanagement/screens/update_password_screen.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({Key? key}) : super(key: key);

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
          budgetvalue = userData["userBudget"] ?? 0; // Update currency value
        });
      }
    }
  }

  void updateUserCurrency(String currency) {
    // Get the current user's document reference
    DocumentReference userRef =
    FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

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
    DocumentReference userRef =
    FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

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
    DocumentReference userRef =
    FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

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
    DocumentReference userRef =
    FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);

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

  @override
  Widget build(BuildContext context) {
    TextEditingController userBudgetController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/moneymap.png',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
          padding: EdgeInsets.all(20),
            children: [

              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(top:30.0),
                child: Text(
                  "General",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: ListTile(
                  title: Text("Set your budget"),
                  subtitle: Text(budgetvalue.toString()),
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
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Currency Settings"),
                  subtitle: Text(currencyvalue),
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
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Currency position"),
                  subtitle: Text(positionvalue),
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
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Decimal places"),
                  subtitle: Text(decimalvalue.toString()),
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
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Change password"),
                  subtitle: Text("Change your password"),
                  leading: Icon(Icons.lock),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Logout"),
                  subtitle: Text("Logout from your account"),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pop(context); // Close the profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    }).onError((error, stackTrace) {
                      print("Error: $error");
                    });
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Delete Account"),
                  subtitle: Text("Delete your account permanently"),
                  leading: Icon(Icons.delete),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Account"),
                          content: Text("Are you sure you want to delete your account?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Delete account logic here
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
