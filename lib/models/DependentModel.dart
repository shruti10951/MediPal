import 'package:cloud_firestore/cloud_firestore.dart';

class DependentModel{
  final String name;
  final String userId;
  final String phoneNo;

  DependentModel({
    required this.userId,
    required this.phoneNo,
    required this.name
  });

  Map<String, dynamic> toMap(){
    return {
      'userId' : userId,
      'phoneNo' : phoneNo,
      'name' : name,
    };
  }

  factory DependentModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DependentModel(
      userId: data['userId'],
      name: data['name'],
      phoneNo: data['phoneNo'],
    );
  }

}