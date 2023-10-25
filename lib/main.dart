import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/bottom_navigation_individual.dart';
import 'package:medipal/notification/notification_service.dart';
import 'package:medipal/user_registration/choose_screen.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:medipal/notification/FirestoreCheck.dart';

import 'Dependent/bottom_navigation_dependent.dart';

Future<void> checkFirestoreTask() async {
  FireStoreCheck check = new FireStoreCheck();
  await check.checkFirestore();
}

Future<List> getData() async {
  final user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot dependentQuery = await firestore
      .collection('dependents')
      .where('userId', isEqualTo: user?.uid.toString())
      .get();
  QuerySnapshot userQuery = await firestore
      .collection('users')
      .where('userId', isEqualTo: user?.uid.toString())
      .get();
  var role;
  if(dependentQuery.docs.isNotEmpty){
    role= 'dependent';
  }else{
    for (QueryDocumentSnapshot document in userQuery.docs) {
      Map<String, dynamic> userData =
      document.data() as Map<String, dynamic>;
      role = userData['role'];
    }
  }
  return ([user, role]);
}
final GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  await NotificationService.initializeNotification();

  await AndroidAlarmManager.initialize();

  const int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), helloAlarmID, checkFirestoreTask);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      ),
      home: MyHomePage(),
      // const MyHomePage(title: 'MediPal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/medipal_splash.png',
              width: 400,
              height: 400,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    var userRole;
    var user;

    getData().then((value) {
      user= value[0];
      userRole = value[1];
      Timer(Duration(seconds: 2), () {
        if (user != null) {
          if (userRole == 'Individual') {
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => BottomNavigationIndividual()),
            );
          } else if (userRole == 'Guardian') {
            navigatorKey.currentState?.pushReplacement(
                MaterialPageRoute(builder: (context) => BottomNavigationIndividual()));
          } else {
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => BottomNavigationDependent()),
            );
          }
        } else {
          navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => ChooseScreen()));
        }
      });
    });

  }
}
