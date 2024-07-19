import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/feature/home/presentations/pages/about_page.dart';
import 'package:some_app/src/feature/home/presentations/pages/home_page.dart';
import 'package:some_app/src/feature/home/presentations/pages/user_page.dart';

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
    const UserPage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_outlined),
                    label: 'Users',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.logout_outlined),
                    label: 'Logout',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: AppColors.secondary,
                onTap: _onItemTapped,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
