import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

import 'dashboard.dart';

import 'enxpenses.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int position = 0;

  final List<Widget> screens = const [Dashboard(), Expenses(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[position],

      bottomNavigationBar: CurvedNavigationBar(
        index: position,
        backgroundColor: fiveColor,
        items: const [
          Icon(Icons.home, color: Colors.black, size: 35),
          Icon(Icons.shopping_bag, color: Colors.black, size: 35),
          Icon(Icons.person, color: Colors.black, size: 35),
        ],
        onTap: (index) {
          setState(() {
            position = index;
          });
        },
      ),
    );
  }
}
