import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String userId;
  String doctorName;
  String location;
  String appointmentTime;
  String description;

  AppointmentModel({required this.userId,
    required this.doctorName,
    required this.location,
    required this.appointmentTime,
    required this.description});

  factory AppointmentModel.fromDocumentSnapshot(DocumentSnapshot snapshot){
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AppointmentModel(userId: data['userId'],
        doctorName: data['doctorName'],
        location: data['location'],
        appointmentTime: data['appointmentTime'],
        description: data['description']);
  }

  Map<String, dynamic> toMap(){
    return{
      'userId' :userId,
      'doctorName' : doctorName,
      'location' : location,
      'appointmentTime' : appointmentTime,
      'description' : description,
    };
  }
}
