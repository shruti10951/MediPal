import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Dependent/gaurdian_view_screen.dart';
import 'inventory_screen_dependent.dart';

class TabChange extends StatelessWidget {
  int _currentIndex = 0;

  final List<Widget> _tabs = [const GaurdianView(), const InventoryScreenDependent()];

  TabChange({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top Navigation Demo'),
          bottom: const TabBar(
            labelColor: Color.fromRGBO(41, 45, 92, 1.0),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Color.fromRGBO(41, 45, 92, 1.0),
                ),
                text: 'Home',
              ),
              Tab(
                icon: Icon(
                  Icons.favorite,
                  color: Color.fromRGBO(41, 45, 92, 1.0),
                ),
                text: 'Inventory',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: _tabs,
        ),
      ),
    );
  }
}
