import 'package:flutter/material.dart';
import 'package:medipal/Individual/welcome_screen.dart';
import 'package:medipal/Dependent/welcome_screen_dependent.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/welcome_background.jpeg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Horizontal Cards
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyCard(
                  title: 'Individual',
                  iconData: Icons.sell,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ));
                  },
                ),
                MyCard(
                  title: 'Dependent',
                  iconData: Icons.usb,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreenDependent(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCard extends StatefulWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPressed; // Callback function for onPressed

  MyCard(
      {required this.title, required this.iconData, required this.onPressed});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.grey.withOpacity(0.7)
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.iconData,
                size: 50.0,
                color: Colors.black,
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
