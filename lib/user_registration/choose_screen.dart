import 'package:flutter/material.dart';
import 'package:medipal/Dependent/welcome_screen_dependent.dart';
import 'package:medipal/Individual/welcome_screen.dart';

class MyCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final onPressed;

  MyCard(
      {required this.title, required this.imagePath, required this.onPressed});

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
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black, width: 2.0), // Add a border
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.imagePath,
                width: 64.0,
                height: 64.0,
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

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 223, 238, 255),
                  Color.fromARGB(214, 152, 191, 255),
                ],
              ),
            ),
          ),
          // Medipal Logo
          Positioned(
            top: 130.0,
            left: 140.0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/medipal.png', // Path to Medipal logo
                  width: 100.0,
                  height: 100.0,
                ),
                const SizedBox(height: 15.0), // Add some spacing
                const Text(
                  "MediPal",
                  style: TextStyle(
                    color: Color.fromARGB(255, 41, 45, 92),
                    fontSize: 26.0, // Adjust the font size as needed
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Horizontal Cards
          Positioned(
            top:360,
            left:10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyCard(
                    title: 'Individual',
                    imagePath:
                        'assets/images/individual.png', // Path to individual image
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 30,),
                  MyCard(
                    title: 'Dependent',
                    imagePath:
                        'assets/images/dependent.png', // Path to dependent image
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreenDependent(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
