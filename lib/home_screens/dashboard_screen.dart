import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medipal/models/AlarmModel.dart';
import 'package:medipal/models/MedicationModel.dart';
import 'bottom_navigation.dart';
import 'medicine_form.dart';

FirebaseAuth auth= FirebaseAuth.instance;
FirebaseFirestore firestore= FirebaseFirestore.instance;
final userId= auth.currentUser?.uid;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _navigateToMedicineForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicineForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

      //add action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToMedicineForm(context); // Call the navigation function
        },
        backgroundColor: const Color.fromARGB(255, 71, 78, 84),
        child: const Icon(Icons.add), // Set the button background color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
    return FutureBuilder(
      future: Future.wait([
        firestore.collection('alarms').where('userId', isEqualTo: userId).get(),
        firestore.collection('medications').where('userId', isEqualTo: userId).get(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, you can show a loading indicator.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error here.
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If there is no data, you can show a message or placeholder.
          return Text('No data found.');
        } else {
          // When the futures are complete and have data, you can build your ListView.
          final alarmQuerySnapshot = snapshot.data![0];
          final medicineQuerySnapshot = snapshot.data![1];

          // Build your widgets here using alarmQuerySnapshot and medicationQuerySnapshot
          // Example: Loop through alarm data and build cards
          return ListView.builder(
            itemCount: alarmQuerySnapshot.size, // Replace with the actual count of cards
            itemBuilder: (BuildContext context, int index) {
              final QueryDocumentSnapshot alarmDocumentSnapshot = alarmQuerySnapshot.docs[index];
              final AlarmModel alarmModel = AlarmModel.fromDocumentSnapshot(alarmDocumentSnapshot);
              final Map<String, dynamic> alarm = alarmModel.toMap();

              // Find the corresponding medication document
              final String medicationId = alarm['medicationId'];
              final DocumentSnapshot? medicationDocumentSnapshot = medicineQuerySnapshot.docs
                  .firstWhere((doc) => doc['medicationId'] == medicationId);

              if (medicationDocumentSnapshot != null) {
                final MedicationModel medicationModel = MedicationModel.fromDocumentSnapshot(medicationDocumentSnapshot);
                final Map<String, dynamic> medicine = medicationModel.toMap();

                final String name = medicine['name'];
                final String time = alarm['time'];
                final String quantity= medicine['dosage'];

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
                        leading: const Icon(Icons.medical_services, size: 48.0, color: Colors.blue),
                        title: Text(
                          name, // Display the medication name
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Quantity: $quantity'), // Display the quantity from the alarm
                      ),
                    ],
                  ),
                );
              } else {
                // Medication not found for this alarm
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Medication not found',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
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
