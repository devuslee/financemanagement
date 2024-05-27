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
    return Expanded(
      child: CustomScrollView(
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
                            onPressed: () {},
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    //if tiles empty return something else else
                    children: tiles.isEmpty
                        ? [

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(150),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center,
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
                      ),
                    ]
                        : tiles,
                  );
                },
                childCount: 1,
              ),
            ),
          ),
    ],
    ),
    );
  }
}