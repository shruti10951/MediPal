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
  bool isScanning = false;

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

  void startScanning() {
    setState(() {
      isScanning = true;
    });
  }

  void onDetect(BarcodeCapture capture) async {
    if (!isProcessingScan) {
      isProcessingScan = true;

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

            dependentList
                .add(FirebaseAuth.instance.currentUser?.uid.toString());

            guardianMap['noOfDependents'] = noOfDependents;
            guardianMap['dependents'] = dependentList;

            await FirebaseFirestore.instance
                .collection('users')
                .doc(guardianId)
                .update(guardianMap);

            dependentAdded = true;
            navigatorKey.currentState?.pop();
            isProcessingScan = false;
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
        title: const Text('QR Scanner For Dependent'),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(156, 0, 0, 0),
          ),
          if (isScanning)
            MobileScanner(
              controller: _mobileScannerController,
              onDetect: onDetect,
            ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Scan QR Code to be a Dependent',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScanning,
        
        child: const Icon(Icons.camera),
      ),
    );
  }
}
