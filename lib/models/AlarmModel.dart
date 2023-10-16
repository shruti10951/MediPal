import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  final String alarmId;
  final String message;
  final String userId;
  final String time;
  final String status;
  final String medicationId;

  AlarmModel(
      {required this.alarmId,
      required this.message,
      required this.userId,
      required this.time,
      required this.status,
      required this.medicationId});

  factory AlarmModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AlarmModel(
      alarmId: data['alarmId'],
      message: data['message'],
      userId: data['userId'],
      time: data['time'],
      status: data['status'],
      medicationId: data['medicationId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alarmId': alarmId,
      'message': message,
      'userId': userId,
      'time': time,
      'status': status,
      'medicationId': medicationId,
    };
  }
}
