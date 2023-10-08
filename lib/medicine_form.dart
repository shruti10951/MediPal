import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/models/MedicationModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class MedicineForm extends StatefulWidget {
  const MedicineForm({super.key});

  @override
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reorderLevelController = TextEditingController();

  TimeOfDay? _morningTime;
  TimeOfDay? _noonTime;
  TimeOfDay? _eveningTime;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
    _reorderLevelController.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Form'),
      ),
      body: SingleChildScrollView(
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
                    controller: _dosageController,
                    decoration: const InputDecoration(
                      labelText: 'Dosage',
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
                    Text(
                        'Selected Morning Time: ${_morningTime!.format(context)}'),
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
                    Text(
                        'Selected Evening Time: ${_eveningTime!.format(context)}'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Create a map to store the medication data
                      final Map<String, dynamic> medicationData = {
                        'name': _nameController.text,
                        'dosage': _dosageController.text,
                        'schedule': {
                          'morning': _morningTime != null
                              ? _morningTime!.format(context)
                              : null,
                          'noon': _noonTime != null
                              ? _noonTime!.format(context)
                              : null,
                          'evening': _eveningTime != null
                              ? _eveningTime!.format(context)
                              : null,
                        },
                        'inventory': {
                          'quantity':
                              int.tryParse(_quantityController.text) ?? 0,
                          'reorderLevel':
                              int.tryParse(_reorderLevelController.text) ?? 0,
                        },
                        'startDate': _startDate != null
                            ? dateFormat.format(_startDate!)
                            : null,
                        'endDate': _endDate != null
                            ? dateFormat.format(_endDate!)
                            : null,
                      };

                      // Handle the form data as needed (e.g., save to Firestore)
                      print('Medication Data: $medicationData');
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
