import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medipal/Individual/bottom_navigation_individual.dart';
import 'package:medipal/models/AlarmModel.dart';
import 'package:medipal/models/MedicationModel.dart';
import '../Dependent/bottom_navigation_dependent.dart';
import 'medicine_form.dart';


//change it to ui wala screen
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = auth.currentUser?.uid;

class DashboardScreenOld extends StatefulWidget {
  const DashboardScreenOld({super.key});

  @override
  _DashboardScreenOldState createState() => _DashboardScreenOldState();
}

class _DashboardScreenOldState extends State<DashboardScreenOld> {
  List<QueryDocumentSnapshot> filteredAlarms = [];

  Future<List<List<QueryDocumentSnapshot>>?> fetchData() async {
    final alarmQuery =
        firestore.collection('alarms').where('userId', isEqualTo: userId).get();
    final medicationQuery = firestore
        .collection('medications')
        .where('userId', isEqualTo: userId)
        .get();

    List<QueryDocumentSnapshot> alarmDocumentList = [];
    List<QueryDocumentSnapshot> medicationDocumentList = [];

    try {
      final results = await Future.wait([alarmQuery, medicationQuery]);
      final alarmQuerySnapshot = results[0] as QuerySnapshot;
      final medicationQuerySnapshot = results[1] as QuerySnapshot;

      if (alarmQuerySnapshot.docs.isNotEmpty) {
        alarmDocumentList = alarmQuerySnapshot.docs.toList();
      }

      if (medicationQuerySnapshot.docs.isNotEmpty) {
        medicationDocumentList = medicationQuerySnapshot.docs.toList();
      }

      return [alarmDocumentList, medicationDocumentList];
    } catch (error) {
      print('Error retrieving documents: $error');
      return null;
    }
  }

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
              'assets/images/medipal.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text('MediPal'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildCalendar(context),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final alarmQuerySnapshot = snapshot.data![0];
                  final medicineQuerySnapshot = snapshot.data![1];
                  return _buildDynamicCards(
                      filteredAlarms.isEmpty
                          ? alarmQuerySnapshot
                          : filteredAlarms,
                      medicineQuerySnapshot);
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationIndividual(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToMedicineForm(context);
        },
        backgroundColor: const Color.fromARGB(255, 71, 78, 84),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 71, 78, 84),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<List<QueryDocumentSnapshot>>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //PLEASE DO SOMETHING ABOUT THIS.
          return _buildLoadingIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error: ${snapshot.error}');
        } else {
          final alarmQuerySnapshot = snapshot.data![0];
          return SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      final currentDate =
                          DateTime.now().add(Duration(days: index));
                      final dayName = DateFormat('E').format(currentDate);
                      final dayOfMonth = currentDate.day.toString();

                      return GestureDetector(
                        onTap: () {
                          _onDateTapped(currentDate, alarmQuerySnapshot);
                        },
                        child: Container(
                          width: 60,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(dayName),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _openCalendar(context, alarmQuerySnapshot);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _openCalendar(BuildContext context,
      List<QueryDocumentSnapshot> alarmQuerySnapshot) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(const Duration(days: 365)),
      lastDate: currentDate.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      print('Selected date: $selectedDate');
      _onDateTapped(selectedDate, alarmQuerySnapshot);
    }
  }

  void _onDateTapped(
      DateTime currentDate, List<QueryDocumentSnapshot> alarmQuerySnapshot) {
    // print(currentDate);
    final List<QueryDocumentSnapshot> alarmFilteredSnapshot =
        alarmQuerySnapshot.where((element) {
      final Map<String, dynamic>? data =
          element.data() as Map<String, dynamic>?;
      if (data != null) {
        final String? date = data['time']?.toString().split(' ')[0];
        // print(date);
        // return 'It is time to take sk' == data['message'].toString();
        return date == currentDate.toString().split(' ')[0];
      } else {
        return false;
      }
    }).toList();

    setState(() {
      filteredAlarms = alarmFilteredSnapshot;
    });
  }

  Widget _buildDynamicCards(List<QueryDocumentSnapshot> alarmQuerySnapshot,
      List<QueryDocumentSnapshot> medicineQuerySnapshot) {
    return ListView.builder(
      itemCount: alarmQuerySnapshot.length,
      itemBuilder: (BuildContext context, int index) {
        final QueryDocumentSnapshot alarmDocumentSnapshot =
            alarmQuerySnapshot[index];

        final AlarmModel alarmModel =
            AlarmModel.fromDocumentSnapshot(alarmDocumentSnapshot);
        final Map<String, dynamic> alarm = alarmModel.toMap();
        final String medicationId = alarm['medicationId'];

        QueryDocumentSnapshot medicationDocument = medicineQuerySnapshot
            .firstWhere((element) => element['medicationId'] == medicationId,
                orElse: null);

        if (medicationDocument != null) {
          final MedicationModel medicationModel =
              MedicationModel.fromDocumentSnapshot(medicationDocument);
          final Map<String, dynamic> medicine = medicationModel.toMap();
          final String name = medicine['name'];
          final String time = alarm['time'];
          final String quantity = medicine['dosage'];

          DateTime dateTime = DateTime.parse(time);

          //check this once again for time and date
          String formattedTime = DateFormat.Hm().format(dateTime);

          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formattedTime,
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
                    name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Quantity: $quantity'),
                ),
              ],
            ),
          );
        } else {
          return const Card(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Medication not found',
                    style: TextStyle(
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
}