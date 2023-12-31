// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:medipal/Individual/bottom_navigation_individual.dart';
// import 'package:medipal/models/AlarmModel.dart';
// import 'package:medipal/models/MedicationModel.dart';

// class MedicineFormDependent extends StatefulWidget {

//   final dependentId;

//   MedicineFormDependent({required this.dependentId});

//   @override
//   _MedicineFormDependentState createState() => _MedicineFormDependentState();
// }

// class _MedicineFormDependentState extends State<MedicineFormDependent> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _dosageController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _reorderLevelController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   TimeOfDay? _morningTime;
//   TimeOfDay? _noonTime;
//   TimeOfDay? _eveningTime;

//   DateTime? _startDate;
//   DateTime? _endDate;

//   String? _selectedDosageType; // Stores the selected dosage type

//   CollectionReference medicationCollectionRef =
//   FirebaseFirestore.instance.collection('medications');
//   CollectionReference alarmCollectionRef =
//   FirebaseFirestore.instance.collection('alarms');
//   FirebaseAuth auth = FirebaseAuth.instance;
//   bool isLoading = false; // Add this to control the loading indicator



//   @override
//   void dispose() {
//     _nameController.dispose();
//     _dosageController.dispose();
//     _quantityController.dispose();
//     _reorderLevelController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectTime(BuildContext context, String timeName) async {
//     final TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (selectedTime != null) {
//       setState(() {
//         if (timeName == 'Morning') {
//           _morningTime = selectedTime;
//         } else if (timeName == 'Noon') {
//           _noonTime = selectedTime;
//         } else if (timeName == 'Evening') {
//           _eveningTime = selectedTime;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat("yyyy-MM-dd");

//     // Define the dropdown items for dosage type
//     final List<DropdownMenuItem<String>> dosageTypeItems = [
//       const DropdownMenuItem(
//         value: 'Pills',
//         child: Row(
//           children: [
//             ImageIcon(
//               AssetImage(
//                   'assets/images/pill_icon.png'), // Replace 'assets/icon.png' with the path to your image
//               size: 28, // Specify the size of the icon
//               color: Color.fromARGB(255, 0, 0, 0), // Specify the color of the icon
//             ),
//             SizedBox(width: 8.0),
//             Text('Pills'),
//           ],
//         ),
//       ),
//       const DropdownMenuItem(
//         value: 'Injection',
//         child: Row(
//           children: [
//             ImageIcon(
//               AssetImage(
//                   'assets/images/injection_icon.png'), // Replace 'assets/icon.png' with the path to your image
//               size: 28, // Specify the size of the icon
//               color: Color.fromARGB(255, 0, 0, 0), // Specify the color of the icon
//             ),
//             SizedBox(width: 8.0),
//             Text('Injection'),
//           ],
//         ),
//       ),
//       const DropdownMenuItem(
//         value: 'Liquid',
//         child: Row(
//           children: [
//             ImageIcon(
//               AssetImage(
//                   'assets/images/liquid_icon.png'), // Replace 'assets/icon.png' with the path to your image
//               size: 28, // Specify the size of the icon
//               color: Color.fromARGB(255, 0, 0, 0), // Specify the color of the icon
//             ),
//             SizedBox(width: 8.0),
//             Text('Liquid'),
//           ],
//         ),
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medicine Form'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 4.0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Medication Details',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   TextField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Medication Name',
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   TextField(
//                     decoration: const InputDecoration(
//                       labelText: 'Dosage Description',
//                     ),
//                     controller: _descriptionController,
//                   ),
//                   const SizedBox(height: 16.0),
//                   DropdownButtonFormField(
//                     value: _selectedDosageType,
//                     decoration: const InputDecoration(
//                       labelText: 'Type of Dosage',
//                     ),
//                     items: dosageTypeItems,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedDosageType = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   TextField(
//                     controller: _dosageController,
//                     decoration: const InputDecoration(
//                       labelText: 'Quatity Per Dose',
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   TextField(
//                     controller: _quantityController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Inventory Quantity',
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   TextField(
//                     controller: _reorderLevelController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Reorder Level',
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   const Text(
//                     'Medication Duration',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   DateTimeField(
//                     format: dateFormat,
//                     decoration: const InputDecoration(
//                       labelText: 'Start Date',
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _startDate = value;
//                       });
//                     },
//                     onShowPicker: (context, currentValue) async {
//                       final date = await showDatePicker(
//                         context: context,
//                         firstDate: DateTime(2000),
//                         initialDate: currentValue ?? DateTime.now(),
//                         lastDate: DateTime(2101),
//                       );
//                       return date;
//                     },
//                   ),
//                   DateTimeField(
//                     format: dateFormat,
//                     decoration: const InputDecoration(
//                       labelText: 'End Date',
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _endDate = value;
//                       });
//                     },
//                     onShowPicker: (context, currentValue) async {
//                       final date = await showDatePicker(
//                         context: context,
//                         firstDate: DateTime(2000),
//                         initialDate: currentValue ?? DateTime.now(),
//                         lastDate: DateTime(2101),
//                       );
//                       return date;
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   const Text(
//                     'Medication Schedule',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   CheckboxListTile(
//                     title: const Text('Morning'),
//                     value: _morningTime != null,
//                     onChanged: (bool? value) {
//                       if (value!) {
//                         _selectTime(context, 'Morning');
//                       } else {
//                         setState(() {
//                           _morningTime = null;
//                         });
//                       }
//                     },
//                   ),
//                   if (_morningTime != null)
//                     Text(
//                         'Selected Morning Time: ${_morningTime!.format(context)}'),
//                   CheckboxListTile(
//                     title: const Text('Noon'),
//                     value: _noonTime != null,
//                     onChanged: (bool? value) {
//                       if (value!) {
//                         _selectTime(context, 'Noon');
//                       } else {
//                         setState(() {
//                           _noonTime = null;
//                         });
//                       }
//                     },
//                   ),
//                   if (_noonTime != null)
//                     Text('Selected Noon Time: ${_noonTime!.format(context)}'),
//                   CheckboxListTile(
//                     title: const Text('Evening'),
//                     value: _eveningTime != null,
//                     onChanged: (bool? value) {
//                       if (value!) {
//                         _selectTime(context, 'Evening');
//                       } else {
//                         setState(() {
//                           _eveningTime = null;
//                         });
//                       }
//                     },
//                   ),
//                   if (_eveningTime != null)
//                     Text(
//                         'Selected Evening Time: ${_eveningTime!.format(context)}'),
//                   const SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () async {
//                       DocumentReference medicationDocumentReference =
//                       medicationCollectionRef.doc();

//                       MedicationModel medication = MedicationModel(
//                         medicationId: medicationDocumentReference.id,
//                         name: _nameController.text,
//                         type: _selectedDosageType.toString(),
//                         dosage: _dosageController.text,
//                         schedule: {
//                           'morning': _morningTime != null
//                               ? _morningTime!.format(context)
//                               : '',
//                           'noon': _noonTime != null
//                               ? _noonTime!.format(context)
//                               : '',
//                           'evening': _eveningTime != null
//                               ? _eveningTime!.format(context)
//                               : '',
//                         },
//                         inventory: {
//                           'quantity':
//                           int.tryParse(_quantityController.text) ?? 0,
//                           'reorderLevel':
//                           int.tryParse(_reorderLevelController.text) ?? 0,
//                         },
//                         startDate: _startDate != null
//                             ? dateFormat.format(_startDate!)
//                             : "",
//                         endDate: _endDate != null
//                             ? dateFormat.format(_endDate!)
//                             : "",
//                         userId: widget.dependentId,
//                         description: _descriptionController.text,
//                       );

//                       Map<String, dynamic> medicationModel = medication.toMap();

//                       await medicationDocumentReference.set(medicationModel);

//                       for (var date = _startDate;
//                       date!.isBefore(_endDate!.add(Duration(days: 1)));
//                       date = date.add(Duration(days: 1))) {
//                         for (var key in medication.schedule.keys) {
//                           final value = medication.schedule[key];
//                           if (value != null && value.isNotEmpty) {
//                             final hrMin = value.split(' ');
//                             final timeParts = hrMin[0].split(':');
//                             final hr = int.tryParse(timeParts[0]);
//                             final min = int.tryParse(timeParts[1]);
//                             if (hr != null && min != null) {
//                               DateTime dateTime = DateTime(
//                                   date.year, date.month, date.day, hr, min);
//                               DocumentReference alarmDocumentReference =
//                               alarmCollectionRef.doc();
//                               String medicineName = _nameController.text;
//                               String message = _dosageController.text;
//                               AlarmModel alarmModel = AlarmModel(
//                                   alarmId: alarmDocumentReference.id,
//                                   skipReason: '',
//                                   userId: widget.dependentId,
//                                   time: dateTime.toString(),
//                                   status: 'pending',
//                                   medicationId: medicationDocumentReference.id);

//                               Map<String, dynamic> alarm = alarmModel.toMap();
//                               await alarmDocumentReference.set(alarm);
//                             }
//                           }
//                         }
//                       }
//                        // Show the toast message
//                       Fluttertoast.showToast(
//                         msg: 'Medicine added successfully!',
//                         toastLength: Toast.LENGTH_SHORT,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Colors.green,
//                         textColor: Colors.white,
//                       );


//                       Navigator.pop(context);

//                       // Handle the form data as needed (e.g., save to Firestore)
//                       // print('Medication Data: $medicationModel');
//                     },
//                     child: const Text('Submit'),
//                   ),
//                 ],
//               ),
//             ), 
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildLoadingIndicator() {
//   return const Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Color.fromARGB(255, 71, 78, 84),
//           ),
//         ),
//         SizedBox(height: 16.0),
//         Text(
//           'Loading...',
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:medipal/Individual/bottom_navigation_individual.dart';
// import 'package:medipal/models/AlarmModel.dart';
// import 'package:medipal/models/MedicationModel.dart';

// class MedicineFormDependent extends StatefulWidget {
//   final dependentId;

//   MedicineFormDependent({required this.dependentId});

//   @override
//   _MedicineFormDependentState createState() => _MedicineFormDependentState();
// }

// class _MedicineFormDependentState extends State<MedicineFormDependent> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _dosageController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _reorderLevelController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   TimeOfDay? _morningTime;
//   TimeOfDay? _noonTime;
//   TimeOfDay? _eveningTime;

//   DateTime? _startDate;
//   DateTime? _endDate;

//   String? _selectedDosageType; // Stores the selected dosage type

//   CollectionReference medicationCollectionRef =
//       FirebaseFirestore.instance.collection('medications');
//   CollectionReference alarmCollectionRef =
//       FirebaseFirestore.instance.collection('alarms');
//   FirebaseAuth auth = FirebaseAuth.instance;
//   bool isLoading = false; // Add this to control the loading indicator

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _dosageController.dispose();
//     _quantityController.dispose();
//     _reorderLevelController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectTime(BuildContext context, String timeName) async {
//     final TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (selectedTime != null) {
//       setState(() {
//         if (timeName == 'Morning') {
//           _morningTime = selectedTime;
//         } else if (timeName == 'Noon') {
//           _noonTime = selectedTime;
//         } else if (timeName == 'Evening') {
//           _eveningTime = selectedTime;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat("yyyy-MM-dd");

//     // Define the dropdown items for dosage type
//     final List<DropdownMenuItem<String>> dosageTypeItems = [
//       const DropdownMenuItem(
//         value: 'Pills',
//         child: Row(
//           children: [
//             ImageIcon(
//               AssetImage('assets/images/pill_icon.png'),
//               size: 28,
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//             SizedBox(width: 8.0),
//             Text('Pills'),
//           ],
//         ),
//       ),
//       const DropdownMenuItem(
//         value: 'Injection',
//         child: Row(
//           children: [
//             ImageIcon(
//               AssetImage('assets/images/injection_icon.png'),
//               size: 28,
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//             SizedBox(width: 8.0),
//             Text('Injection'),
//           ],
//         ),
//       ),
//       const DropdownMenuItem(
//         value: 'Liquid',
//         child: Row(
//           children: [
//             ImageIcon(
//               AssetImage('assets/images/liquid_icon.png'),
//               size: 28,
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//             SizedBox(width: 8.0),
//             Text('Liquid'),
//           ],
//         ),
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medicine Form'),
//       ),
//       body: isLoading
//           ? _buildLoadingIndicator()
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Card(
//                   elevation: 4.0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Medication Details',
//                           style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextField(
//                           controller: _nameController,
//                           decoration: const InputDecoration(
//                             labelText: 'Medication Name',
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextField(
//                           decoration: const InputDecoration(
//                             labelText: 'Dosage Description',
//                           ),
//                           controller: _descriptionController,
//                         ),
//                         const SizedBox(height: 16.0),
//                         DropdownButtonFormField(
//                           value: _selectedDosageType,
//                           decoration: const InputDecoration(
//                             labelText: 'Type of Dosage',
//                           ),
//                           items: dosageTypeItems,
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedDosageType = value;
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextField(
//                           controller: _dosageController,
//                     keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: 'Quantity Per Dose',
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextField(
//                           controller: _quantityController,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: 'Inventory Quantity',
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextField(
//                           controller: _reorderLevelController,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: 'Reorder Level',
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         const Text(
//                           'Medication Duration',
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         DateTimeField(
//                           format: dateFormat,
//                           decoration: const InputDecoration(
//                             labelText: 'Start Date',
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               _startDate = value;
//                             });
//                           },
//                           onShowPicker: (context, currentValue) async {
//                             final date = await showDatePicker(
//                               context: context,
//                               firstDate: DateTime(2000),
//                               initialDate: currentValue ?? DateTime.now(),
//                               lastDate: DateTime(2101),
//                             );
//                             return date;
//                           },
//                         ),
//                         DateTimeField(
//                           format: dateFormat,
//                           decoration: const InputDecoration(
//                             labelText: 'End Date',
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               _endDate = value;
//                             });
//                           },
//                           onShowPicker: (context, currentValue) async {
//                             final date = await showDatePicker(
//                               context: context,
//                               firstDate: DateTime(2000),
//                               initialDate: currentValue ?? DateTime.now(),
//                               lastDate: DateTime(2101),
//                             );
//                             return date;
//                           },
//                         ),
//                         const SizedBox(height: 16.0),
//                         const Text(
//                           'Medication Schedule',
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         CheckboxListTile(
//                           title: const Text('Morning'),
//                           value: _morningTime != null,
//                           onChanged: (bool? value) {
//                             if (value!) {
//                               _selectTime(context, 'Morning');
//                             } else {
//                               setState(() {
//                                 _morningTime = null;
//                               });
//                             }
//                           },
//                         ),
//                         if (_morningTime != null)
//                           Text('Selected Morning Time: ${_morningTime!.format(context)}'),
//                         CheckboxListTile(
//                           title: const Text('Noon'),
//                           value: _noonTime != null,
//                           onChanged: (bool? value) {
//                             if (value!) {
//                               _selectTime(context, 'Noon');
//                             } else {
//                               setState(() {
//                                 _noonTime = null;
//                               });
//                             }
//                           },
//                         ),
//                         if (_noonTime != null)
//                           Text('Selected Noon Time: ${_noonTime!.format(context)}'),
//                         CheckboxListTile(
//                           title: const Text('Evening'),
//                           value: _eveningTime != null,
//                           onChanged: (bool? value) {
//                             if (value!) {
//                               _selectTime(context, 'Evening');
//                             } else {
//                               setState(() {
//                                 _eveningTime = null;
//                               });
//                             }
//                           },
//                         ),
//                         if (_eveningTime != null)
//                           Text('Selected Evening Time: ${_eveningTime!.format(context)}'),
//                         const SizedBox(height: 16.0),
//                         ElevatedButton(
//                           onPressed: () async {
//                             // Set isLoading to true before performing async tasks
//                             setState(() {
//                               isLoading = true;
//                             });

//                             DocumentReference medicationDocumentReference =
//                                 medicationCollectionRef.doc();

//                       MedicationModel medication = MedicationModel(
//                         medicationId: medicationDocumentReference.id,
//                         name: _nameController.text,
//                         type: _selectedDosageType.toString(),
//                         dosage: int.parse(_dosageController.text),
//                         schedule: {
//                           'morning': _morningTime != null
//                               ? _morningTime!.format(context)
//                               : '',
//                           'noon': _noonTime != null
//                               ? _noonTime!.format(context)
//                               : '',
//                           'evening': _eveningTime != null
//                               ? _eveningTime!.format(context)
//                               : '',
//                         },
//                         inventory: {
//                           'quantity':
//                           int.tryParse(_quantityController.text) ?? 0,
//                           'reorderLevel':
//                           int.tryParse(_reorderLevelController.text) ?? 0,
//                         },
//                         startDate: _startDate != null
//                             ? dateFormat.format(_startDate!)
//                             : "",
//                         endDate: _endDate != null
//                             ? dateFormat.format(_endDate!)
//                             : "",
//                         userId: widget.dependentId,
//                         description: _descriptionController.text,
//                       );

//                             Map<String, dynamic> medicationModel = medication.toMap();

//                             await medicationDocumentReference.set(medicationModel);

//                             for (var date = _startDate;
//                                 date!.isBefore(_endDate!.add(Duration(days: 1)));
//                                 date = date.add(Duration(days: 1))) {
//                               for (var key in medication.schedule.keys) {
//                                 final value = medication.schedule[key];
//                                 if (value != null && value.isNotEmpty) {
//                                   final hrMin = value.split(' ');
//                                   final timeParts = hrMin[0].split(':');
//                                   final hr = int.tryParse(timeParts[0]);
//                                   final min = int.tryParse(timeParts[1]);
//                                   if (hr != null && min != null) {
//                                     DateTime dateTime = DateTime(
//                                         date.year, date.month, date.day, hr, min);
//                                     DocumentReference alarmDocumentReference =
//                                         alarmCollectionRef.doc();
//                                     String medicineName = _nameController.text;
//                                     String message = _dosageController.text;
//                                     AlarmModel alarmModel = AlarmModel(
//                                         alarmId: alarmDocumentReference.id,
//                                         skipReason: '',
//                                         userId: widget.dependentId,
//                                         time: dateTime.toString(),
//                                         status: 'pending',
//                                         medicationId: medicationDocumentReference.id);

//                                     Map<String, dynamic> alarm = alarmModel.toMap();
//                                     await alarmDocumentReference.set(alarm);
//                                   }
//                                 }
//                               }
//                             }

//                             // Set isLoading back to false
//                             setState(() {
//                               isLoading = false;
//                             });

//                             // Show the toast message
//                             Fluttertoast.showToast(
//                               msg: 'Medicine added successfully!',
//                               toastLength: Toast.LENGTH_SHORT,
//                               gravity: ToastGravity.BOTTOM,
//                               backgroundColor: Colors.green,
//                               textColor: Colors.white,
//                             );

//                             Navigator.pop(context); // Navigate to the inventory screen
//                           },
//                           child: const Text('Submit'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }

// Widget _buildLoadingIndicator() {
//   return const Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Color.fromARGB(255, 71, 78, 84),
//           ),
//         ),
//         SizedBox(height: 16.0),
//         Text(
//           'Loading...',
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     ),
//   );
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:medipal/Individual/bottom_navigation_individual.dart';
import 'package:medipal/models/AlarmModel.dart';
import 'package:medipal/models/MedicationModel.dart';

class MedicineFormDependent extends StatefulWidget {
  final dependentId;

  MedicineFormDependent({required this.dependentId});

  @override
  _MedicineFormDependentState createState() => _MedicineFormDependentState();
}

class _MedicineFormDependentState extends State<MedicineFormDependent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reorderLevelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TimeOfDay? _morningTime;
  TimeOfDay? _noonTime;
  TimeOfDay? _eveningTime;

  DateTime? _startDate;
  DateTime? _endDate;

  String? _selectedDosageType; // Stores the selected dosage type

  CollectionReference medicationCollectionRef =
      FirebaseFirestore.instance.collection('medications');
  CollectionReference alarmCollectionRef =
      FirebaseFirestore.instance.collection('alarms');
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false; // Add this to control the loading indicator

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
    _reorderLevelController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, String timeName) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        if (timeName == 'Morning') {
          _morningTime = selectedTime;
        } else if (timeName == 'Noon') {
          _noonTime = selectedTime;
        } else if (timeName == 'Evening') {
          _eveningTime = selectedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("yyyy-MM-dd");

    // Define the dropdown items for dosage type
    final List<DropdownMenuItem<String>> dosageTypeItems = [
      const DropdownMenuItem(
        value: 'Pills',
        child: Row(
          children: [
            ImageIcon(
              AssetImage('assets/images/pill_icon.png'),
              size: 28,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            SizedBox(width: 8.0),
            Text('Pills'),
          ],
        ),
      ),
      const DropdownMenuItem(
        value: 'Injection',
        child: Row(
          children: [
            ImageIcon(
              AssetImage('assets/images/injection_icon.png'),
              size: 28,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            SizedBox(width: 8.0),
            Text('Injection'),
          ],
        ),
      ),
      const DropdownMenuItem(
        value: 'Liquid',
        child: Row(
          children: [
            ImageIcon(
              AssetImage('assets/images/liquid_icon.png'),
              size: 28,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            SizedBox(width: 8.0),
            Text('Liquid'),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Form'),
      ),
      body: isLoading
          ? _buildLoadingIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Medication Details',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Medication Name',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Dosage Description',
                          ),
                          controller: _descriptionController,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField(
                          value: _selectedDosageType,
                          decoration: const InputDecoration(
                            labelText: 'Type of Dosage',
                          ),
                          items: dosageTypeItems,
                          onChanged: (value) {
                            setState(() {
                              _selectedDosageType = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _dosageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity Per Dose',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Inventory Quantity',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _reorderLevelController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Reorder Level',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Medication Duration',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DateTimeField(
                          format: dateFormat,
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _startDate = value;
                            });
                          },
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            return date;
                          },
                        ),
                        DateTimeField(
                          format: dateFormat,
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _endDate = value;
                            });
                          },
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            return date;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Medication Schedule',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CheckboxListTile(
                          title: const Text('Morning'),
                          value: _morningTime != null,
                          onChanged: (bool? value) {
                            if (value!) {
                              _selectTime(context, 'Morning');
                            } else {
                              setState(() {
                                _morningTime = null;
                              });
                            }
                          },
                        ),
                        if (_morningTime != null)
                          Text('Selected Morning Time: ${_morningTime!.format(context)}'),
                        CheckboxListTile(
                          title: const Text('Noon'),
                          value: _noonTime != null,
                          onChanged: (bool? value) {
                            if (value!) {
                              _selectTime(context, 'Noon');
                            } else {
                              setState(() {
                                _noonTime = null;
                              });
                            }
                          },
                        ),
                        if (_noonTime != null)
                          Text('Selected Noon Time: ${_noonTime!.format(context)}'),
                        CheckboxListTile(
                          title: const Text('Evening'),
                          value: _eveningTime != null,
                          onChanged: (bool? value) {
                            if (value!) {
                              _selectTime(context, 'Evening');
                            } else {
                              setState(() {
                                _eveningTime = null;
                              });
                            }
                          },
                        ),
                        if (_eveningTime != null)
                          Text('Selected Evening Time: ${_eveningTime!.format(context)}'),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            // Set isLoading to true before performing async tasks
                            setState(() {
                              isLoading = true;
                            });

                            DocumentReference medicationDocumentReference =
                                medicationCollectionRef.doc();

                            MedicationModel medication = MedicationModel(
                              medicationId: medicationDocumentReference.id,
                              name: _nameController.text,
                              type: _selectedDosageType.toString(),
                              dosage: int.parse(_dosageController.text),
                              schedule: {
                                'morning': _morningTime != null
                                    ? _morningTime!.format(context)
                                    : '',
                                'noon': _noonTime != null
                                    ? _noonTime!.format(context)
                                    : '',
                                'evening': _eveningTime != null
                                    ? _eveningTime!.format(context)
                                    : '',
                              },
                              inventory: {
                                'quantity':
                                int.tryParse(_quantityController.text) ?? 0,
                                'reorderLevel':
                                int.tryParse(_reorderLevelController.text) ?? 0,
                              },
                              startDate: _startDate != null
                                  ? dateFormat.format(_startDate!)
                                  : "",
                              endDate: _endDate != null
                                  ? dateFormat.format(_endDate!)
                                  : "",
                              userId: widget.dependentId,
                              description: _descriptionController.text,
                            );

                            Map<String, dynamic> medicationModel = medication.toMap();

                            await medicationDocumentReference.set(medicationModel);

                            for (var date = _startDate;
                                date!.isBefore(_endDate!.add(Duration(days: 1)));
                                date = date.add(Duration(days: 1))) {
                              for (var key in medication.schedule.keys) {
                                final value = medication.schedule[key];
                                if (value != null && value.isNotEmpty) {
                                  final hrMin = value.split(' ');
                                  final timeParts = hrMin[0].split(':');
                                  final hr = int.tryParse(timeParts[0]);
                                  final min = int.tryParse(timeParts[1]);
                                  if (hr != null && min != null) {
                                    DateTime dateTime = DateTime(
                                        date.year, date.month, date.day, hr, min);
                                    DocumentReference alarmDocumentReference =
                                        alarmCollectionRef.doc();
                                    String medicineName = _nameController.text;
                                    String message = _dosageController.text;
                                    AlarmModel alarmModel = AlarmModel(
                                        alarmId: alarmDocumentReference.id,
                                        skipReason: '',
                                        userId: widget.dependentId,
                                        time: dateTime.toString(),
                                        status: 'pending',
                                        medicationId: medicationDocumentReference.id);

                                    Map<String, dynamic> alarm = alarmModel.toMap();
                                    await alarmDocumentReference.set(alarm);
                                  }
                                }
                              }
                            }

                            // Set isLoading back to false
                            setState(() {
                              isLoading = false;
                            });

                            // Show the toast message
                            Fluttertoast.showToast(
                              msg: 'Medicine added successfully!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );

                            Navigator.pop(context, medication); // Pass data back to the home screen
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
