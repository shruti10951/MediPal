import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationModel {
  final String medicationId;
  final String name;
  final String dosage;
  final Map<String, dynamic> schedule;
  final Map<String, dynamic> inventory;
  final String startDate;
  final String endDate;
  final String userId;

  MedicationModel({
    required this.medicationId,
    required this.name,
    required this.dosage,
    required this.schedule,
    required this.inventory,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  factory MedicationModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return MedicationModel(
      medicationId: data['medicationId'],
      name: data['name'],
      dosage: data['dosage'],
      schedule: data['schedule'],
      inventory: data['inventory'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicationId': medicationId,
      'name': name,
      'dosage': dosage,
      'schedule': schedule,
      'inventory': inventory,
      'startDate': startDate,
      'endDate': endDate,
      'userId': userId,
    };
  }
}
