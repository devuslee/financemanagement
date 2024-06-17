import 'package:flutter/material.dart';
import 'package:financemanagement/reusable_widget/FromCountryCard.dart';
import 'package:financemanagement/reusable_widget/ToCountryCard.dart';
import 'package:financemanagement/main.dart';
import 'package:provider/provider.dart';


class ConvertedCurrency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: FromCountryCard(
              image: '${Provider.of<Data>(context).initialCur}Flag.png',
              currencyAmount: '1000',
              currencyName: Provider.of<Data>(context).inputAmount,
            ),
          ),

          Icon(
            Icons.arrow_right_alt_outlined,
            size: 80,
            color: Color(0xFF3A7B1E),
          ),
          ToCountryCard(
              image: '${Provider.of<Data>(context).finalCur}Flag.png',
              currencyAmount: '730',
              currencyName: Provider.of<Data>(context).updatedRate
          ),
        ],
      );
  }
}