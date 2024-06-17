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
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:financemanagement/main.dart';

final List<List<String>> IncometransactionCategoryLists = [["Loading...", "Loading"]];
final List<List<String>> ExpensetransactionCategoryLists = [["Loading...", "Loading"]];

int count = 0;
final Map<String, IconData> iconMapping = {
  'Food': Icons.fastfood,
  'Home': Icons.home,
  'Person': Icons.person,
  'Shopping': Icons.shopping_cart,
  'Car': Icons.car_rental,
  'Health': Icons.health_and_safety,
  'Education': Icons.book,
  'Entertainment': Icons.movie,
  'Baby': Icons.baby_changing_station,
  'Social': Icons.event,
  'Business': Icons.business,
  'Gift': Icons.card_giftcard,
  'Investment': Icons.attach_money,
  'Loan': Icons.money_off,
  'Salary': Icons.money,
};


String IconText = "";

class CategoryContent extends StatefulWidget {
  const CategoryContent({super.key});

  @override
  State<CategoryContent> createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {

  TextEditingController categoryNameController = TextEditingController();
  String transactionCategoryValue = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
            print(Expensecategories);
          });

          Expensecategories.sort((a, b) => a[0].compareTo(b[0])); //make sure the categories always display in the same manner


          setState(() {
            ExpensetransactionCategoryLists.clear();
            ExpensetransactionCategoryLists.addAll(Expensecategories);
            count = count + 1;
            if (ExpensetransactionCategoryLists.isNotEmpty) {
              transactionCategoryValue = ExpensetransactionCategoryLists[count].first;
            }
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
            print(Incomecategories);
          });

          Incomecategories.sort((a, b) => a[0].compareTo(b[0])); //make sure the categories always display in the same manner


          setState(() {
            IncometransactionCategoryLists.clear();
            IncometransactionCategoryLists.addAll(Incomecategories);
            count = count + 1;
            if (IncometransactionCategoryLists.isNotEmpty) {
              transactionCategoryValue = IncometransactionCategoryLists[count].first;
            }
          });
        }
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Failed to fetch categories: $e");
    }

    count = 0;
  }



  @override
  Widget build(BuildContext context) {
    bool isExpense = true;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      List<Widget> IncomeTiles = [];
                      List<Widget> ExpenseTiles = [];

                      for (var transactionCategoryList in ExpensetransactionCategoryLists) {
                        ExpenseTiles.add(
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
                                  borderRadius: BorderRadius.circular(
                                      8.0),
                                  child: Icon(
                                    iconMapping[transactionCategoryList[1]],
                                    size: 40,
                                    color: Colors.black,
                                  )
                              ),
                              title: Text(
                                transactionCategoryList[0],
                                style: TextStyle(
                                  fontSize: 20,

                                ),
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey,
                                ),
                                onSelected: (String result) {
                                  if (result == 'delete') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Category'),
                                          content: SingleChildScrollView(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.4, // Adjust the width as needed
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Are you sure you want to delete this category? Deleting it will result in all transactions associated with this category being deleted as well.',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  var currentUser = FirebaseAuth.instance.currentUser!.uid;

                                                  // References to the Firestore collections
                                                  DocumentReference categoryDocRef = FirebaseFirestore.instance
                                                      .collection("Categories")
                                                      .doc(currentUser);

                                                  Query<Map<String, dynamic>> transactionQuery = FirebaseFirestore.instance
                                                      .collection("Transaction")
                                                      .where('transactionCategory', isEqualTo: transactionCategoryList[0])
                                                      .where('transactionUserID', isEqualTo: currentUser);

                                                  // Delete the category from the Categories collection
                                                  await categoryDocRef.update({
                                                    transactionCategoryList[0]: FieldValue.delete(),
                                                  });

                                                  // Fetch and delete all transactions associated with the category
                                                  QuerySnapshot<Map<String, dynamic>> transactionSnapshot = await transactionQuery.get();
                                                  for (var doc in transactionSnapshot.docs) {
                                                    await doc.reference.delete();
                                                  }

                                                  // Close the dialog and refresh the categories
                                                  Navigator.of(context).pop();
                                                  fetchCategories();
                                                } catch (e) {
                                                  // Handle any errors
                                                  print("Failed to delete category: $e");
                                                  // Optionally, show an alert dialog to inform the user of the error
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text("Failed to delete category: $e"),
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
                                              child: Text('Delete', style: TextStyle(color: Colors.red)),
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
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      for (var transactionCategoryList in IncometransactionCategoryLists) {
                        IncomeTiles.add(
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
                                borderRadius: BorderRadius.circular(
                                    8.0),
                                child: Icon(
                                  iconMapping[transactionCategoryList[1]],
                                  size: 40,
                                  color: Colors.black,
                                )
                              ),
                              title: Text(
                                transactionCategoryList[0],
                                style: TextStyle(
                                  fontSize: 20,

                                ),
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey,
                                ),
                                onSelected: (String result) {
                                  if (result == 'delete') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Category'),
                                          content: SingleChildScrollView(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.4, // Adjust the width as needed
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Are you sure you want to delete this category? Deleting it will result in all transactions associated with this category being deleted as well.',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  var currentUser = FirebaseAuth.instance.currentUser!.uid;

                                                  // References to the Firestore collections
                                                  DocumentReference categoryDocRef = FirebaseFirestore.instance
                                                      .collection("Categories")
                                                      .doc(currentUser);

                                                  Query<Map<String, dynamic>> transactionQuery = FirebaseFirestore.instance
                                                      .collection("Transaction")
                                                      .where('transactionCategory', isEqualTo: transactionCategoryList[0])
                                                      .where('transactionUserID', isEqualTo: currentUser);

                                                  // Delete the category from the Categories collection
                                                  await categoryDocRef.update({
                                                    transactionCategoryList[0]: FieldValue.delete(),
                                                  });

                                                  // Fetch and delete all transactions associated with the category
                                                  QuerySnapshot<Map<String, dynamic>> transactionSnapshot = await transactionQuery.get();
                                                  for (var doc in transactionSnapshot.docs) {
                                                    await doc.reference.delete();
                                                  }

                                                  // Close the dialog and refresh the categories
                                                  Navigator.of(context).pop();
                                                  fetchCategories();
                                                } catch (e) {
                                                  // Handle any errors
                                                  print("Failed to delete category: $e");
                                                  // Optionally, show an alert dialog to inform the user of the error
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text("Failed to delete category: $e"),
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
                                              child: Text('Delete', style: TextStyle(color: Colors.red)),
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
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        // If tiles is empty, return the "No transactions found" message, else return the tiles
                        children: ExpenseTiles.isEmpty
                            ? [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(150),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    height: 100,
                                    width: 100,
                                    "assets/images/empty_transaction.png", // Use any icon you prefer
                                  ),
                                  SizedBox(height: 40),
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
                          ), // Add the "hello" text here
                        ]
                            : [
                          SizedBox(height:30),
                          Text(
                            "Expense Categories",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...ExpenseTiles,
                          SizedBox(height:20),
                          Text(
                            "Income Categories",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...IncomeTiles,
                          Container(
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String categoryName = ''; // Store the input category name
                                    IconData selectedIcon = Icons.category;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text('Add Category'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                onChanged: (value) {
                                                  categoryName = value; // Update the category name when input changes
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Enter Category Name',
                                                ),
                                                controller: categoryNameController,
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue: isExpense,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isExpense = true;
                                                      });
                                                    },
                                                  ),
                                                  Text('Expense'),
                                                  Radio(
                                                    value: false,
                                                    groupValue: isExpense,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isExpense = false;
                                                      });
                                                    },
                                                  ),
                                                  Text('Income'),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.fastfood,
                                                      color: selectedIcon == Icons.fastfood ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.fastfood;
                                                        IconText = "Food";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.shopping_cart,
                                                      color: selectedIcon == Icons.shopping_cart ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.shopping_cart;
                                                        IconText = "Shopping";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.home,
                                                      color: selectedIcon == Icons.home ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.home;
                                                        IconText = "Home";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.person,
                                                      color: selectedIcon == Icons.person ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.person;
                                                        IconText = "Person";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.car_rental,
                                                      color: selectedIcon == Icons.car_rental ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.car_rental;
                                                        IconText = "Car";
                                                      });
                                                    },
                                                  ),
                                                ],
                                            ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.health_and_safety,
                                                      color: selectedIcon == Icons.health_and_safety ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.health_and_safety;
                                                        IconText = "Health";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.book,
                                                      color: selectedIcon == Icons.book ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.book;
                                                        IconText = "Education";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.movie,
                                                      color: selectedIcon == Icons.movie ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.movie;
                                                        IconText = "Entertainment";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.baby_changing_station,
                                                      color: selectedIcon == Icons.baby_changing_station ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.baby_changing_station;
                                                        IconText = "Baby";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.event,
                                                      color: selectedIcon == Icons.event ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.event;
                                                        IconText = "Social";
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.business,
                                                      color: selectedIcon == Icons.business ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.business;
                                                        IconText = "Business";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.card_giftcard,
                                                      color: selectedIcon == Icons.card_giftcard ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.card_giftcard;
                                                        IconText = "Gift";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.attach_money,
                                                      color: selectedIcon == Icons.attach_money ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.attach_money;
                                                        IconText = "Investment";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.money_off,
                                                      color: selectedIcon == Icons.money_off ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.money_off;
                                                        IconText = "Loan";
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.money,
                                                      color: selectedIcon == Icons.money ? Colors.blue : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIcon = Icons.money;
                                                        IconText = "Salary";
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (isExpense == true) {
                                                  try {
                                                    DocumentReference collRef = FirebaseFirestore
                                                        .instance
                                                        .collection("ExpenseCategories")
                                                        .doc(FirebaseAuth.instance
                                                        .currentUser?.uid);

                                                    await collRef.update({
                                                      '${categoryNameController
                                                          .text}': IconText,
                                                    });

                                                    // Close the dialog
                                                    Navigator.of(context).pop();
                                                    fetchCategories();
                                                  } catch (e) {
                                                    // Handle any errors
                                                    print(
                                                        "Failed to add category: $e");
                                                    // Optionally, show an alert dialog to inform the user of the error
                                                    showDialog(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Error"),
                                                          content: Text(
                                                              "Failed to add category: $e"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                    context).pop();
                                                              },
                                                              child: Text("OK"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  try {
                                                    DocumentReference collRef = FirebaseFirestore
                                                        .instance
                                                        .collection("IncomeCategories")
                                                        .doc(FirebaseAuth.instance
                                                        .currentUser?.uid);

                                                    await collRef.update({
                                                      '${categoryNameController
                                                          .text}': IconText,
                                                    });

                                                    // Close the dialog
                                                    Navigator.of(context).pop();
                                                    fetchCategories();
                                                  } catch (e) {
                                                    // Handle any errors
                                                    print(
                                                        "Failed to add category: $e");
                                                    // Optionally, show an alert dialog to inform the user of the error
                                                    showDialog(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Error"),
                                                          content: Text(
                                                              "Failed to add category: $e"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                    context).pop();
                                                              },
                                                              child: Text("OK"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                              child: Text('Add'),
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
                                );
                              },
                              child: Text(
                                "Add Category",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.grey.withOpacity(0.1),
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 30,
                                  ),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 45),
                        ],
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }
}

Future<IconData> updateCategoryIcon(String categoryName) async {
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

