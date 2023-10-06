class UserModel{
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

  Map<String, dynamic> toMap(){
    return {
      'userId' : userId,
      'email' : email,
      'phoneNo' : phoneNo,
      'name' : name,
      'role' : role,
      'noOfDependents' : noOfDependents,
      'dependents' : dependents,
    };
  }

}