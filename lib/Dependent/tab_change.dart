import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medipal/Individual/gaurdian_view_screen.dart';
import 'package:medipal/Individual/inventory_dependet_guardian.dart';
import 'inventory_screen_dependent.dart';

class TabChange extends StatefulWidget {
  int _currentIndex = 0;

  final dependentId;

  TabChange({required this.dependentId});

  @override
  _TabChangeState createState() => _TabChangeState();

}

class _TabChangeState extends State<TabChange> {

  late final List<Widget> _tabs;


  @override
  void initState() {
    super.initState();
    _tabs = [
      GaurdianView(dependentId: widget.dependentId),
      InventoryDependentGuardian(dependentId: widget.dependentId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top Navigation Demo'),
          bottom: TabBar(
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

  // [const GaurdianView(dependent: dependentId), const InventoryScreenDependent()];



