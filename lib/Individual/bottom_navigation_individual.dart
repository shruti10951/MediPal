import 'package:flutter/material.dart';
import 'package:medipal/Dependent/dashboard_screen_dependent.dart';
import 'package:medipal/Individual/dashboard_screen.dart';
import 'package:medipal/Individual/profile_screen.dart';
import 'package:medipal/Individual/inventory_screen.dart';
import 'package:medipal/home_screens/dashboard_screen_old.dart';

class BottomNavigationIndividual extends StatefulWidget {
  const BottomNavigationIndividual({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigationIndividual> {
  int _selectedIndex = 0; // Current selected tab index
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Function to navigate to the Inventory page
  void _navigateToInventory() {
    _pageController.animateToPage(
      1, // Index of the Inventory tab
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _navigateToProfile() {
    _pageController.animateToPage(
      2, // Index of the Profile tab
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _navigateToDashboard() {
    _pageController.animateToPage(
      0, // Index of the Dashboard tab
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          DashboardScreen(), // Replace with your Dashboard screen widget
          InventoryScreen(), // Replace with your Inventory screen widget
          ProfileScreen(), // Replace with your Profile screen widget

          // Add other screens as needed
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Add logic to navigate to specific pages based on index
          switch (index) {
            case 0:
              _navigateToDashboard();
              break;
            case 1:
              _navigateToInventory();
              break;
            case 2:
              _navigateToProfile();
              break;
            // Add other cases for additional tabs
          }
        },
      ),
    );
  }
}
