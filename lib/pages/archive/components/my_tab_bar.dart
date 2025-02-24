import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
          dividerColor: Colors.transparent,
          controller: tabController,
          tabs: const [
            Tab(
              text: "Vente",
            ),
            Tab(
              text: "Casier",
            ),
            Tab(
              text: "Boisson",
            ),
          ]),
    );
  }
}
