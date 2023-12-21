import 'package:flutter/material.dart';

class AppointmentDependentScreen extends StatefulWidget {
  const AppointmentDependentScreen({super.key});

  @override
  _AppointmentDependentScreenState createState() => _AppointmentDependentScreenState();
}

class _AppointmentDependentScreenState extends State<AppointmentDependentScreen> {
  List<AppointmentData> appointmentList = [
    AppointmentData(
      doctorName: 'Dr. John Doe',
      date: 'December 25, 2023',
      time: '10:00 AM',
      location: 'Hospital XYZ',
      description: 'Regular check-up',
    ),
    AppointmentData(
      doctorName: 'Dr. Jane Smith',
      date: 'January 5, 2024',
      time: '2:30 PM',
      location: 'Clinic ABC',
      description: 'Consultation for allergy',
    ),
    AppointmentData(
      doctorName: 'Dr. Minal Smith',
      date: 'January 5, 2024',
      time: '2:30 PM',
      location: 'Clinic ABC',
      description: 'Consultation for allergy',
    ),
    AppointmentData(
      doctorName: 'Dr. Reshma Smith',
      date: 'January 5, 2024',
      time: '2:30 PM',
      location: 'Clinic ABC',
      description: 'Consultation for allergy',
    ),
    AppointmentData(
      doctorName: 'Dr. Shruti Smith',
      date: 'January 5, 2024',
      time: '2:30 PM',
      location: 'Clinic ABC',
      description: 'Consultation for allergy',
    ),
    AppointmentData(
      doctorName: 'Dr. Janhavi Smith',
      date: 'January 5, 2024',
      time: '2:30 PM',
      location: 'Clinic ABC',
      description: 'Consultation for allergy',
    ),
    AppointmentData(
      doctorName: 'Dr. NAmita ',
      date: 'January 5, 2024',
      time: '2:30 PM',
      location: 'Clinic ABC',
      description: 'Consultation for allergy',
    ),
    // Add more appointments here as needed
  ];

  List<AppointmentData> filteredAppointments = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    filteredAppointments = appointmentList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search by Doctor Name',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterAppointments(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (BuildContext context, int index) {
                return AppointmentCardHolder(
                  appointmentData: filteredAppointments[index],
                  onDelete: () {
                    _showDeleteDialog(index);
                  },
                  onEdit: () {
                    _showEditDialog(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterAppointments(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredAppointments = appointmentList
            .where((appointment) => appointment.doctorName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      } else {
        filteredAppointments = appointmentList;
      }
    });
  }

  void _showEditDialog(int index) {
    TextEditingController doctorNameController =
        TextEditingController(text: appointmentList[index].doctorName);
    TextEditingController dateController =
        TextEditingController(text: appointmentList[index].date);
    TextEditingController timeController =
        TextEditingController(text: appointmentList[index].time);
    TextEditingController locationController =
        TextEditingController(text: appointmentList[index].location);
    TextEditingController descriptionController =
        TextEditingController(text: appointmentList[index].description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: doctorNameController,
                  decoration: const InputDecoration(labelText: 'Doctor\'s Name'),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Update appointmentList with the edited values
                        setState(() {
                          appointmentList[index].doctorName =
                              doctorNameController.text;
                          appointmentList[index].date = dateController.text;
                          appointmentList[index].time = timeController.text;
                          appointmentList[index].location =
                              locationController.text;
                          appointmentList[index].description =
                              descriptionController.text;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Appointment'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete this appointment?'),
              Text(
                'Note: Deleting this appointment will also delete the associated alarms.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  appointmentList.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class AppointmentData {
  late final String doctorName;
  late final String date;
  late final String time;
  late final String location;
  late final String description;

  AppointmentData({
    required this.doctorName,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
  });
}

class AppointmentCardHolder extends StatelessWidget {
  final AppointmentData appointmentData;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AppointmentCardHolder({
    required this.appointmentData,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                appointmentData.doctorName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Date', appointmentData.date),
                  _buildInfoRow('Time', appointmentData.time),
                  _buildInfoRow('Location', appointmentData.location),
                  _buildInfoRow('Description', appointmentData.description),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
