import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financemanagement/screens/currency_page.dart';
import 'package:financemanagement/main.dart';

class FromCountryCard extends StatelessWidget {
  final String image;
  final String currencyAmount;
  final String currencyName;

  FromCountryCard({required this.image, required this.currencyAmount, required this.currencyName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2), // Adjust the padding to set the border thickness
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black, // Border color
              width: 2.0, // Border width
            ),
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('flags/$image'),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '${(Provider.of<Data>(context).inputAmount == null) ? '0' : Provider.of<Data>(context).inputAmount} ${(Provider.of<Data>(context).initialCurDisplay == null) ? 'AUD' : Provider.of<Data>(context).initialCurDisplay}',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
