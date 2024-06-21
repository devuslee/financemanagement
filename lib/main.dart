import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financemanagement/screens/signin_screen.dart';
import 'package:financemanagement/screens/signup_screen.dart';
import 'package:financemanagement/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financemanagement/screens/currency_page.dart';
import 'package:financemanagement/screens/signin_screen.dart';


String? globalUID;

Color appbar = Colors.grey.shade100;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBBjGyHjJNEre4wqjgcZd2Sk3JTiFAO_kc",
      appId: "1:744836218062:android:723df5b600dc412d2fa49f",
      messagingSenderId: "744836218062",
      projectId: "financemanagement-ead7b",
    ),
  );
  await getUserID();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blueAccent,
            scaffoldBackgroundColor: Color(0xFF00142F),
            textTheme: TextTheme(
                bodyText2: TextStyle(
                    color: Colors.black
                )
            )
        ),
        home: const SplashScreen(),
      ),
    );
  }
}


Future<void> getUserID() async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      globalUID = user.uid;
      print("User ID: ${user.uid}");
    } else {
      print("User is not signed in");
    }
  } catch (e) {
    print("Error retrieving user ID: $e");
  }
}

class Data extends ChangeNotifier{
  String initialCur='AUD';
  String finalCur='USD';
  String updatedRate = "0";
  String inputAmount = "0";
  String? outputAmount;
  String? initialCurDisplay;
  String? finalCurDisplay;

  void changeInitial(String newInitial){
    initialCur=newInitial;
    notifyListeners();
  }
  void changeFinal(String newFinal){
    finalCur=newFinal;
    notifyListeners();
  }
  void changeRate(String newRate){
    updatedRate=newRate;
    notifyListeners();
  }

  void enterAmount(String newInput){
    inputAmount=newInput;
    notifyListeners();
  }
  void updateInitialCurDisplay(String newInput){
    initialCurDisplay=newInput;
  }
  void updateFinalCurDisplay(String newInput){
    finalCurDisplay=newInput;
  }
  void calcConvertedAmount(String rate ){
    outputAmount=(double.parse(inputAmount)*double.parse(updatedRate)).toStringAsFixed(2);
    notifyListeners();
  }
}
