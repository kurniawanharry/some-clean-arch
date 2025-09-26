import 'package:flutter/material.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/feature/home/presentations/pages/about_page.dart';
import 'package:some_app/src/feature/home/presentations/pages/home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      showExitDialog(context);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  final List<Widget> _screens = [
    const HomePage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_screens[_selectedIndex]],
      ),
    );
  }
}
