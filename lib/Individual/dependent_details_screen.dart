import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Dependent/tab_change.dart';

class DependentDetailsScreen extends StatefulWidget {
  @override
  _DependentDetailsScreenState createState() => _DependentDetailsScreenState();
}

class _DependentDetailsScreenState extends State<DependentDetailsScreen> {
  final List<Map<String, dynamic>> dependentData = [];

  Future<List<Map<String, dynamic>>> fetchData() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .get();

    final userData = user.data() as Map<String, dynamic>;

    List<String> dependentList = List<String>.from(userData['dependents']);

    List<Map<String, dynamic>> dependentsData = [];
    for (var d in dependentList) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dependent')
          .where('userId', isEqualTo: d)
          .get();
      final documents = querySnapshot.docs;
      if (documents.isNotEmpty) {
        final Map<String, dynamic> dependentData =
            documents.first.data() as Map<String, dynamic>;
        dependentsData.add(dependentData);
      }
    }
    return dependentsData;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dependent Details'),
      ),
      body: Center(
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                } else {
                  final dependentsData = snapshot;
                  return ListView.builder(
                    itemCount: dependentsData.data?.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic>? dependent =
                          dependentsData.data?[index];
                      return _buildDependentCard(context, dependent!);
                    },
                  );
                }
              })),
    );
  }

  Widget _buildDependentCard(BuildContext context, Map<String, dynamic> data) {
    // List of image URLs for dependent profiles
    List<String> imageUrls = [
      'https://cdn-icons-png.flaticon.com/512/4128/4128253.png',
      'https://w7.pngwing.com/pngs/666/201/png-transparent-computer-icons-woman-women-s-day-face-holidays-head-thumbnail.png',
      
    ];

    // Generate a random index to select an image URL
    int randomIndex = data.hashCode % imageUrls.length;
    String imageUrl = imageUrls[randomIndex];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TabChange(
                    dependentId: data['userId'],
                  )),
        );
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(
            data['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            data['phoneNo'],
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
