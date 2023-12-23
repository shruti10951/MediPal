import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/edit_medicine_depedent_form.dart';
import 'package:medipal/models/MedicationModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class InventoryDependentGuardian extends StatefulWidget {
  final dependentId;

  InventoryDependentGuardian({required this.dependentId});

  @override
  _InventoryDependentGuardian createState() => _InventoryDependentGuardian();
}

class _InventoryDependentGuardian extends State<InventoryDependentGuardian> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<QueryDocumentSnapshot>?> fetchData() async {
    final medicationQuery = firestore
        .collection('medications')
        .where('userId', isEqualTo: widget.dependentId)
        .get();

    List<QueryDocumentSnapshot> medicationDocumentList = [];

    try {
      final results = await Future.wait([medicationQuery]);
      final medicationQuerySnapshot = results[0];

      if (medicationQuerySnapshot.docs.isNotEmpty) {
        medicationDocumentList = medicationQuerySnapshot.docs.toList();
      }
      return medicationDocumentList;
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error retrieving documents',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 240, 91, 91),
        textColor: const Color.fromARGB(255, 255, 255, 255),
      );
      return null;
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dosageController = TextEditingController();

  // Function to open an edit dialog for a specific item
  void _openEditDialog(
      String id, String name, String type, int quantity, int dosage) {
    nameController.text = name;
    quantityController.text = quantity.toString();
    dosageController.text = dosage.toString();
    typeController.text = type;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Medication'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Medication Name'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: type,
                    onChanged: (String? newValue) {
                      setState(() {
                        type = newValue!;
                      });
                    },
                    items: <String>['Pills', 'Liquid', 'Injection']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        key: UniqueKey(),
                        value: value,
                        child: Row(
                          children: [
                            if (value == 'Pills')
                              Container(
                                height: 24, // Specify the height you want
                                width: 24, // Specify the width you want
                                child: Image.asset(
                                    'assets/images/pill_icon.png'), // Replace 'assets/pills.png' with the actual image path
                              ),
                            if (value == 'Liquid')
                              Container(
                                height: 24, // Specify the height you want
                                width: 24, // Specify the width you want
                                child: Image.asset(
                                    'assets/images/liquid_icon.png'), // Replace 'assets/liquid.png' with the actual image path
                              ),
                            if (value == 'Injection')
                              Container(
                                height: 24, // Specify the height you want
                                width: 24, // Specify the width you want
                                child: Image.asset(
                                    'assets/images/injection_icon.png'), // Replace 'assets/injection.png' with the actual image path
                              ),
                            const SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dosageController,
                    decoration:
                        const InputDecoration(labelText: 'Dosage Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      type = typeController.text;
                    });
                    Navigator.pop(context);
                    // Refresh the page after data is deleted
                    setState(() {});
                  },
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    String updatedName = nameController.text;
                    String updatedType = typeController.text;
                    int updatedQuantity =
                        int.tryParse(quantityController.text) ?? 0;
                    int updatedDosage =
                        int.tryParse(dosageController.text) ?? 0;
                    // Use updatedType for the selected medicine type
                    // Update the item in the database

                    Map<String, dynamic> medicine = {
                      'name': updatedName,
                      'inventory.quantity': updatedQuantity,
                      'type': type,
                      'dosage': updatedDosage,
                    };

                    firestore
                        .collection('medications')
                        .doc(id)
                        .update(medicine)
                        .then(
                          (value) => Fluttertoast.showToast(
                            msg: 'Data updated',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                const Color.fromARGB(206, 2, 191, 34),
                            textColor: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        );
                    // print('data updated'));
                    Navigator.pop(context);
                    // Refresh the page after data is deleted
                    setState(() {});
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to open a confirmation dialog for deleting a specific item
  void _openDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete this medication?'),
              Text(
                'Note: Deleting this medication will also delete all associated alarms.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                firestore
                    .collection('medications')
                    .doc(id)
                    .delete()
                    .then((value) async {
                  final snapshots = await firestore
                      .collection('alarms')
                      .where('medicationId', isEqualTo: id)
                      .get();
                  for (final doc in snapshots.docs) {
                    await doc.reference.delete();
                  }
                });

                Navigator.pop(context);
                // Refresh the page after data is deleted
                setState(() {});
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();

                // return const CircularProgressIndicator();
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
          final type = medication['type'];
          final medicationId = medication['medicationId'];
          final dosage = medication['dosage'];
          final quantity = medication['inventory']['quantity'];

          String img;

          if (medication['medicationImg'] == '') {
            if (type == 'Pills') {
              img =
                  'https://firebasestorage.googleapis.com/v0/b/medipal-61348.appspot.com/o/medication_icons%2Fpill_icon.png?alt=media&token=8967025a-597f-4d82-8b39-d705e2e051b4';
            } else if (type == 'Liquid') {
              img =
                  'https://firebasestorage.googleapis.com/v0/b/medipal-61348.appspot.com/o/medication_icons%2Fliquid_icon.png?alt=media&token=0541a72d-b74c-439e-8d40-2851bbc421aa';
            } else {
              img =
                  'https://firebasestorage.googleapis.com/v0/b/medipal-61348.appspot.com/o/medication_icons%2Finjection_icon.png?alt=media&token=95b4de3d-4cc3-41c1-b254-f4552d5d4545';
            }
          } else {
            img = medication['medicationImg'];
          }
          Widget Imgbuild(BuildContext context) {
            double width = 80.0;
            double height = 80.0;
            if (medication['medicationImg'] == '') {
              width = 64.0;
              height = 64.0;
              return Image(image: NetworkImage(img));
            } else {
              width = 80.0;
              height = 80.0;
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(img),
                  ),
                ),
              );
            }
          }

          // Add this in UI
          final recorder = medication['inventory']['recorderLevel'];

          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Imgbuild(context),
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
                      // For this, make sure we have type in medicine form
                      Text('Type: $type'),
                      Text('Quantity: $quantity'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Open the edit dialog when the edit button is pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DependentMedicineFormEdit(medicationId: medicationId, dependentId: widget.dependentId,),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Open the delete confirmation dialog when the delete button is pressed
                              _openDeleteDialog(medicationId);
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
