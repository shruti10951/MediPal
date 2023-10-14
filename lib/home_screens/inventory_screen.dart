import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/models/MedicationModel.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = auth.currentUser?.uid;

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Future<List<QueryDocumentSnapshot>?> fetchData() async {
    final medicationQuery = firestore
        .collection('medications')
        .where('userId', isEqualTo: userId)
        .get();

    List<QueryDocumentSnapshot> medicationDocumentList = [];

    try {
      final results = await Future.wait([medicationQuery]);
      final medicationQuerySnapshot = results[0] as QuerySnapshot;

      if (medicationQuerySnapshot.docs.isNotEmpty) {
        medicationDocumentList = medicationQuerySnapshot.docs.toList();
      }
      return medicationDocumentList;
    } catch (error) {
      print('Error retrieving documents: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final medicationQuery = snapshot.data;
                return _buildInventoryCard(medicationQuery!);
              }
            },
          ))
        ],
      ), // Create the inventory list view
    );
  }

  Widget _buildInventoryCard(
      List<QueryDocumentSnapshot> medicationQuerySnapshot) {
    return ListView.builder(
        itemCount: medicationQuerySnapshot.length,
        itemBuilder: (BuildContext context, int index) {
          final QueryDocumentSnapshot medicationDocumentSnapshot =
              medicationQuerySnapshot[index];
          final MedicationModel medicationModel =
              MedicationModel.fromDocumentSnapshot(medicationDocumentSnapshot);
          final Map<String, dynamic> medication = medicationModel.toMap();
          final name = medication['name'];
          final quantity = medication['inventory']['quantity'];

          //add this in ui
          final recorder = medication['inventory']['recorderLevel'];

          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Image.asset('assets/images/MediPal.png'),
                  // Replace with your image asset
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1, color: Colors.grey),
                      // Vertical line
                      const SizedBox(height: 8),
                      //for this make sure we have type in medicine form
                      const Text('Type: Medicine Type'),
                      Text('Quantity: $quantity'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Implement edit functionality
                              //here show a dialogue box or something to allow user to edit

                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Implement delete functionality
                              // again here show some warning message
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
        });
  }
}
