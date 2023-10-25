import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medipal/models/AlarmModel.dart';
import 'package:medipal/models/MedicationModel.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = auth.currentUser?.uid;

class GaurdianView extends StatefulWidget {
  const GaurdianView({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _GaurdianViewState createState() => _GaurdianViewState();
}

class _GaurdianViewState extends State<GaurdianView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/medipal.png',
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
          _buildCalendar(context),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //PLEASE DO SOMETHING ABOUT THIS.
                  return _buildLoadingIndicator();
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

                      
                    },
                  ),
                ),
                
              ],
            ),
          );
        }
      },
    );
  }




  Widget _buildDynamicCards(List<QueryDocumentSnapshot> alarmQuerySnapshot,
      List<QueryDocumentSnapshot> medicineQuerySnapshot) {
    // Implement your dynamic vertical cards here based on data
    // You can use a ListView.builder to create a list of cards.
    // Provide functions to fetch and handle the card data.
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
          final String type = medicine['type'];

          String img;

          if(type=='Pills'){
            img= 'assets/images/pill_icon.png';
          }else if(type=='Liquid'){
            img= 'assets/images/liquid_icon.png';
          }else{
            img= 'assets/images/injection_icon.png';
          }

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
                  leading: Image.asset(img),
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

