import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medipal/dashboard_screen.dart';
import 'package:medipal/user_selection_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDcbHs9PIXgOwHLpOfcMu3B7h4gKrl8dNI",
        authDomain: "medipal-61348.firebaseapp.com",
        projectId: "medipal-61348",
        storageBucket: "medipal-61348.appspot.com",
        messagingSenderId: "507903652085",
        appId: "1:507903652085:web:23e5c1a05cb570695fd5bc",
        measurementId: "G-EMMXM8CBPH",
      ),
    );
  } else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MediPal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(widget.title),
      ),
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
    final user= FirebaseAuth.instance.currentUser;
    Timer(Duration(seconds: 2), () {
      if(user != null){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserSelection()));
      }
    });
  }
}
