import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medipal/bottom_navigation.dart';

class DashboardScreenDependent extends StatefulWidget {
  const DashboardScreenDependent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreenDependent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/MediPal.png',
              width: 30, // Adjust the width as needed
              height: 30, // Adjust the height as needed
            ),
            const SizedBox(width: 8), // Add spacing
            const Text('MediPal'), // Title next to the image
          ],
        ),
      ),
      body: Column(
        children: [
          _buildCalendar(context), // Horizontal scrollable calendar
          const Divider(), // Horizontal line
          Expanded(
            child: _buildDynamicCards(), // Dynamic vertical cards
          ),
        ],
      ),
      //bottomNavigation bar
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return SizedBox(
      height: 100, // Adjust the height as needed
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7, // One week calendar
              itemBuilder: (BuildContext context, int index) {
                final currentDate = DateTime.now().add(Duration(days: index));
                final dayName = DateFormat('E').format(currentDate);
                final dayOfMonth = currentDate.day.toString();

                return Container(
                  width: 60, // Adjust the width as needed
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        dayOfMonth,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dayName),
                    ],
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Open the calendar when the button is clicked
              _openCalendar(context);
            },
          ),
        ],
      ),
    );
  }

  void _openCalendar(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate:
          currentDate.subtract(const Duration(days: 365)), // One year ago
      lastDate: currentDate.add(const Duration(days: 365)), // One year from now
    );

    if (selectedDate != null) {
      // Handle the selected date here (e.g., update the UI with the selected date)
      print('Selected date: $selectedDate');
    }
  }

  Widget _buildDynamicCards() {
    // Implement your dynamic vertical cards here based on data
    // You can use a ListView.builder to create a list of cards.
    // Provide functions to fetch and handle the card data.
    return ListView.builder(
      itemCount: _getCardCount(), // Replace with the actual count of cards
      itemBuilder: (BuildContext context, int index) {
        return _buildCard(index); // Create individual cards
      },
    );
  }

  int _getCardCount() {
    // Implement a function to determine the number of cards based on data
    // Return the actual count of cards
    return 10; // Example count, replace with your logic
  }

  Widget _buildCard(int index) {
    final List<String> times = [
      'Morning',
      'Noon',
      'Evening',
      'Night'
    ]; // Replace with your times
    final String time = times[index % 4]; // Example: Cycle through times

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.medical_services,
                size: 48.0, color: Colors.blue),
            title: Text(
              'Medicine Name $index', // Replace with actual medicine name
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Quantity: $index'), // Replace with actual quantity
          ),
        ],
      ),
    );
  }
}
