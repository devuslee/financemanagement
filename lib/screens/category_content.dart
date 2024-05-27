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

final List<String> transactionCategoryLists = ["Loading..."];

class CategoryContent extends StatefulWidget {
  const CategoryContent({super.key});

  @override
  State<CategoryContent> createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {


  String transactionCategoryValue = transactionCategoryLists.isNotEmpty ? transactionCategoryLists.first : '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();

        if (data != null) {
          List<String> categories = [];
          data.forEach((key, value) {
            categories.add(value.toString());
          });

          categories.sort(); //make sure the categories always display in the same manner


          setState(() {
            transactionCategoryLists.clear();
            transactionCategoryLists.addAll(categories);
            if (transactionCategoryLists.isNotEmpty) {
              transactionCategoryValue = transactionCategoryLists.first;
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
    return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  List<Widget> tiles = [];

                  for (var transactionCategoryList in transactionCategoryLists) {
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
                            borderRadius: BorderRadius.circular(
                                8.0),
                            child: Image.asset(
                              "assets/images/shopping.png",
                            ),
                          ),
                          title: Text(
                            transactionCategoryList,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                            },
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    // If tiles is empty, return the "No transactions found" message, else return the tiles
                    children: tiles.isEmpty
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
                      ), // Add the "hello" text here
                    ]
                        : [

                      ...tiles,
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
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.local_hospital,
                                                  color: selectedIcon == Icons.local_hospital ? Colors.blue : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedIcon = Icons.local_hospital;
                                                  });
                                                },
                                              ),
                                            ],
                                        ),
                                      ],
                                    ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Perform actions when the 'Add' button is pressed
                                            // You can add category to Firestore here
                                            Navigator.of(context).pop(); // Close the dialog
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
                      )
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
          ),
        ],
      );
  }
}

