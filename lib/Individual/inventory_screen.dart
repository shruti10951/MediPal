import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bottom_navigation.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: _buildInventoryList(),
            bottomNavigationBar: const BottomNavigation(),
 // Create the inventory list view
    );
  }

  Widget _buildInventoryList() {
    // Replace this with your actual inventory data or use a ListView.builder
    return ListView(
      children: [
        _buildInventoryCard(),
        _buildInventoryCard(),
        // Add more inventory cards here
      ],
    );
  }

  Widget _buildInventoryCard() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Image.asset(
                'assets/images/MediPal.png'), // Replace with your image asset
            title: const Text(
              'Medicine Name',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Colors.grey), // Vertical line
                const SizedBox(height: 8),
                const Text('Type: Medicine Type'),
                const Text('Quantity: X units'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Implement edit functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Implement delete functionality
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
