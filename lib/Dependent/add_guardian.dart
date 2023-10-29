import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AddGuardian extends StatefulWidget {
  @override
  _AddGuardianState createState() => _AddGuardianState();
}

class _AddGuardianState extends State<AddGuardian> {
  MobileScannerController? _mobileScannerController;

  bool dependentAdded = false;
  bool isProcessingScan = false;

  @override
  void initState() {
    super.initState();

    _mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _mobileScannerController?.dispose();

    super.dispose();
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Scan Successful"),
          content: Text("The QR Code was successfully scanned."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void onDetect(BarcodeCapture capture) async {
    if (!isProcessingScan) {
      if (!dependentAdded) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        var guardianId;

        for (final barcode in barcodes) {
          guardianId = barcode.rawValue;
        }

        if (guardianId != null) {
          var guardianData = await FirebaseFirestore.instance
              .collection('users')
              .doc(guardianId)
              .get();

          if (guardianData.exists) {
            Map<String, dynamic> guardianMap =
                guardianData.data() as Map<String, dynamic>;

            var noOfDependents = guardianMap['noOfDependents'] + 1;
            var dependentList = guardianMap['dependents'];

            dependentList.add(FirebaseAuth.instance.currentUser?.uid.toString());

            guardianMap['noOfDependents'] = noOfDependents;
            guardianMap['dependents'] = dependentList;

            await FirebaseFirestore.instance
                .collection('users')
                .doc(guardianId)
                .update(guardianMap);

            dependentAdded = true;
            navigatorKey.currentState?.pop();

            showSuccessDialog(context); // Show the success dialog
          } else {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            scaffoldMessenger.showSnackBar(const SnackBar(
              content: Text('Wrong QR Code!!'),
              duration: Duration(seconds: 3),
            ));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Guardian QR Code'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(41.0), // Add padding here
          child: Container(
            width: 700,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              border: Border.all(
                color: Color.fromARGB(255, 123, 123, 123), // Border color
                width: 4.0,           // Border width
              ),
            ),
            child: MobileScanner(
              fit: BoxFit.contain,
              controller: _mobileScannerController,
              onDetect: onDetect,
            ),
          ),
        ),
      ),
    );
  }
}
