import 'package:flutter/material.dart';

class DependentDetailsScreen extends StatefulWidget {
  @override
  _DependentDetailsScreenState createState() => _DependentDetailsScreenState();
}

class _DependentDetailsScreenState extends State<DependentDetailsScreen> {
  final List<Map<String, dynamic>> dependentData = [
    {
      'title': 'Dependent Name 1',
      'subtitle': 'Phone: 123-456-7890',
      'imageUrl': 'https://example.com/dependent_profile_1.jpg',
    },
    {
      'title': 'Dependent Name 2',
      'subtitle': 'Phone: 123-456-7891',
      'imageUrl': 'https://example.com/dependent_profile_2.jpg',
    },
    // Add more dependent data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dependent Details'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: dependentData.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data = dependentData[index];
            return _buildDependentCard(data);
          },
        ),
      ),
    );
  }

  Widget _buildDependentCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        // Navigate to a dependent-specific screen here
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
            backgroundImage: NetworkImage(data['imageUrl']),
          ),
          title: Text(
            data['title'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            data['subtitle'],
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
