import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medipal/Individual/medicine_form_dependent.dart';
import 'package:medipal/models/AlarmModel.dart';
import 'package:medipal/models/MedicationModel.dart';

import 'dashboard_screen.dart';

class GaurdianView extends StatefulWidget {
  final dependentId;

  const GaurdianView({required this.dependentId});

  @override
  _GaurdianViewState createState() => _GaurdianViewState();
}

class _GaurdianViewState extends State<GaurdianView> {

  List<QueryDocumentSnapshot> filteredAlarms = [];
  // List<QueryDocumentSnapshot> alarmQuerySnapshot = [];

  late QuerySnapshot<Object?> alarmQuerySnapshot;

  Future<List<List<QueryDocumentSnapshot>>?> fetchData() async {
    final alarmQuery = firestore
        .collection('alarms')
        .where('userId', isEqualTo: widget.dependentId)
        .get();
    final medicationQuery = firestore
        .collection('medications')
        .where('userId', isEqualTo: widget.dependentId)
        .get();

    List<QueryDocumentSnapshot> alarmDocumentList = [];
    List<QueryDocumentSnapshot> medicationDocumentList = [];

    try {
      final results =
      await Future.wait([alarmQuery, medicationQuery] as Iterable<Future>);
      alarmQuerySnapshot = results[0] as QuerySnapshot;
      final medicationQuerySnapshot = results[1] as QuerySnapshot;

      if (alarmQuerySnapshot.docs.isNotEmpty) {
        alarmDocumentList = alarmQuerySnapshot.docs.toList();
      }

      if (medicationQuerySnapshot.docs.isNotEmpty) {
        medicationDocumentList = medicationQuerySnapshot.docs.toList();
      }

      return [alarmDocumentList, medicationDocumentList];
    } catch (error) {
      print('Error retrieving documents: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final alarmQuerySnapshot = snapshot.data![0];
                  final medicineQuerySnapshot = snapshot.data![1];
                  return _buildDynamicCards(
                      filteredAlarms.isEmpty
                          ? alarmQuerySnapshot
                          : filteredAlarms,
                      medicineQuerySnapshot);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 100,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.pending_actions_rounded),
          ),
        ],
      ),
    );
  }

  void _showAction(BuildContext context, int index) {
    if (index == 0) {
      _openCalendar(context);
    } else if (index == 1) {
      // Open Medicine Form screen here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicineFormDependent(dependentId: widget.dependentId,),
        ),
      );
    }
    // Add additional conditions for other action buttons if needed
  }

  void _openCalendar(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate:
      currentDate.subtract(const Duration(days: 365)), // One year ago
      lastDate: currentDate.add(const Duration(days: 365)), // One year from now
    );

    if(selectedDate != null){
      _onDateTapped(selectedDate, alarmQuerySnapshot);
    }
  }

  void _onDateTapped(
      DateTime currentDate, QuerySnapshot<Object?> alarmQuerySnapshot) {
    // print(currentDate);
    final List<QueryDocumentSnapshot> alarmFilteredSnapshot =
    alarmQuerySnapshot.docs.where((element) {
      final Map<String, dynamic>? data =
      element.data() as Map<String, dynamic>?;
      if (data != null) {
        final String? date = data['time']?.toString().split(' ')[0];
        // print(date);
        // return 'It is time to take sk' == data['message'].toString();
        return date == currentDate.toString().split(' ')[0];
      } else {
        return false;
      }
    }).toList();

    setState(() {
      filteredAlarms = alarmFilteredSnapshot;
    });
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

  Widget _buildDynamicCards(List<QueryDocumentSnapshot> alarmQuerySnapshot,
      List<QueryDocumentSnapshot> medicineQuerySnapshot) {
    alarmQuerySnapshot.sort((a, b){
      final DateTime timeA= DateTime.parse(a['time']);
      final DateTime timeB= DateTime.parse(b['time']);
      return timeA.compareTo(timeB);
    });
    return ListView.builder(
      itemCount: alarmQuerySnapshot.length,
      itemBuilder: (BuildContext context, int index) {
        final QueryDocumentSnapshot alarmDocumentSnapshot =
        alarmQuerySnapshot[index];

        final AlarmModel alarmModel =
        AlarmModel.fromDocumentSnapshot(alarmDocumentSnapshot);
        final Map<String, dynamic> alarm = alarmModel.toMap();
        final String medicationId = alarm['medicationId'];

        QueryDocumentSnapshot medicationDocument = medicineQuerySnapshot
            .firstWhere((element) => element['medicationId'] == medicationId,
            orElse: null);

        if (medicationDocument != null) {
          final MedicationModel medicationModel =
          MedicationModel.fromDocumentSnapshot(medicationDocument);
          final Map<String, dynamic> medicine = medicationModel.toMap();
          final String name = medicine['name'];
          final String time = alarm['time'];
          final int quantity = medicine['dosage'];
          final String type = medicine['type'];

          String img;

          if (type == 'Pills') {
            img = 'assets/images/pill_icon.png';
          } else if (type == 'Liquid') {
            img = 'assets/images/liquid_icon.png';
          } else {
            img = 'assets/images/injection_icon.png';
          }

          DateTime dateTime = DateTime.parse(time);

          //check this once again for time and date
          // String formattedTime = DateFormat.Hm().format(dateTime);
          // DateTime dateTime = DateTime.parse(time);

// Format the date portion of the timestamp as "day month" (e.g., "21 Sept")
          String formattedDate = DateFormat('d MMM').format(dateTime);

// Format the time portion of the timestamp as "H:mm" (e.g., "9:00")
          String formattedTime = DateFormat.Hm().format(dateTime);

          String dateTimeText = '$formattedDate | $formattedTime';

          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dateTimeText,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                ListTile(
                  leading: Image.asset(img),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Quantity: $quantity'),
                ),
              ],
            ),
          );
        } else {
          return const Card(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Medication not found',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
    i < count;
    i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      height: isBig ? 128 : 36,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.grey.shade300,
      ),
    );
  }
}