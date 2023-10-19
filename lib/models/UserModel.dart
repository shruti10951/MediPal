import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String phoneNo;
  final String name;
  final String role;
  final int noOfDependents;
  final List<String> dependents;


  UserModel({
    required this.userId,
    required this.email,
    required this.phoneNo,
    required this.name,
    required this.role,
    required this.noOfDependents,
    required this.dependents,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'phoneNo': phoneNo,
      'name': name,
      'role': role,
      'noOfDependents': noOfDependents,
      'dependents': dependents,
    };
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      userId: data['userId'],
      email: data['email'],
      phoneNo: data['phoneNo'],
      name: data['name'],
      role: data['role'],
      noOfDependents: data['noOfDependents'],
      dependents: data['dependents'],
    );
  }
}
