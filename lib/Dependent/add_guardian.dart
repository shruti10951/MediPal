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
        title: const Text('Scan guardian QR code'),
      ),
      body: MobileScanner(
        fit: BoxFit.contain,
        controller: _mobileScannerController,
        onDetect: onDetect,
      ),
    );
  }
}