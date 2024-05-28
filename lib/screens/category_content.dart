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

final List<List<String>> transactionCategoryLists = [["Loading...", "Loading"]];
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
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
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

          categories.sort((a, b) => a[0].compareTo(b[0])); //make sure the categories always display in the same manner


          setState(() {
            transactionCategoryLists.clear();
            transactionCategoryLists.addAll(categories);
            count = count + 1;
            if (transactionCategoryLists.isNotEmpty) {
              transactionCategoryValue = transactionCategoryLists[count].first;
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
                                            controller: categoryNameController,
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
                                      ],
                                    ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {

                                            try {

                                              DocumentReference collRef = FirebaseFirestore.instance
                                                  .collection("Categories")
                                                  .doc(FirebaseAuth.instance.currentUser?.uid);

                                              await collRef.update({
                                                '${categoryNameController.text}': IconText,
                                              });

                                              // Close the dialog
                                              Navigator.of(context).pop();
                                              fetchCategories();
                                            } catch (e) {
                                              // Handle any errors
                                              print("Failed to add category: $e");
                                              // Optionally, show an alert dialog to inform the user of the error
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text("Failed to add category: $e"),
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

