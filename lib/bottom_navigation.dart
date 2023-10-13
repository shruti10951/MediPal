import 'package:flutter/material.dart';

import 'Individual/inventory_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0; // Current selected tab index

  // Function to navigate to the Inventory page
  void _navigateToInventory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const InventoryScreen()), // Navigate to InventoryScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      onTap: _onTabTapped,
    );
  }

  // Function to handle tab selection

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // You can add navigation logic here to switch between tabs.
    // For example, you can use a switch statement to navigate to different screens.

    switch (index) {
      case 0:
        // Navigate to Dashboard
        break;
      case 1:
        // Navigate to Inventory
        _navigateToInventory(
            context); // Call the function when Inventory tab is selected
        break;
      case 2:
        // Navigate to Profile
        break;
    }
  }

  // Add your navigation logic here to switch between tabs.
  // For example, you can use a switch statement to navigate to different screens.
}
