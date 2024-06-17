import 'package:financemanagement/reusable_widget/ConvertedCurrency.dart';
import 'package:financemanagement/reusable_widget/ReusableCard.dart';
import 'package:flutter/material.dart';
import 'package:financemanagement/reusable_widget/ExchangeRate.dart';
import 'package:financemanagement/reusable_widget/ConversionList.dart';

class CurrencyPage extends StatefulWidget {
  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),

      ),
      backgroundColor: Colors.transparent, // Ensure this matches your app's theme
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/moneymap.png',
              fit: BoxFit.cover,
            ),
          ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text(
                  'Currency Converter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              ReusableCard(cardChild: ConvertedCurrency()),
              SizedBox(
                height: 15,
              ),
              ReusableCard(cardChild: ExchangeRate()),
              SizedBox(
                height: 15,
              ),
              ReusableCard(cardChild: ConversionList()),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
