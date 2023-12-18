import 'package:cloud_firestore/cloud_firestore.dart';

class DependentModel{
  final String name;
  final String userId;
  final String phoneNo;
  final int noOfGuardian;
  final List<String> guardians;

  DependentModel({
    required this.userId,
    required this.phoneNo,
    required this.name,
    required this.noOfGuardian,
    required this.guardians,
  });

  Map<String, dynamic> toMap(){
    return {
      'userId' : userId,
      'phoneNo' : phoneNo,
      'name' : name,
      'dependents' : guardians,
      'noOfDependents' : noOfGuardian,
    };
  }

  factory DependentModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DependentModel(
      userId: data['userId'],
      name: data['name'],
      phoneNo: data['phoneNo'],
      guardians: data['dependents'],
      noOfGuardian: data['noOfDependents'],
    );
  }

}