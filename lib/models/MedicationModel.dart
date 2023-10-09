class MedicationModel {
  final String medicationId;
  final String name;
  final String dosage;
  final Map<String, String> schedule;
  final Map<String, int> inventory;
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
