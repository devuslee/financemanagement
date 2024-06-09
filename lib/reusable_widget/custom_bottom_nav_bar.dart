import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/moneymap.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          // Make bottom navigation bar transparent
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFFFAACA8), // Set selected item color
          unselectedItemColor: Color(0xFFDDD6F3), // Set unselected item color
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ],
    );
  }
}
