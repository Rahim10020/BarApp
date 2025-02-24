import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:projet7/pages/home/components/my_drawer.dart';
import 'package:projet7/pages/archive/archive_page.dart';
import 'package:projet7/pages/bar/bar_page.dart';
import 'package:projet7/pages/commande/commande_page.dart';
import 'package:projet7/pages/vente/vente_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    const BarPage(),
    const VentePage(),
    const CommandePage(),
    const ArchivePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Mon Bar"),
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            activeColor: Theme.of(context).colorScheme.inversePrimary,
            tabBackgroundColor: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(8),
            gap: 8,
            onTabChange: (index) {
              navigateBottomBar(index);
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.attach_money,
                text: "Ventes",
              ),
              GButton(
                icon: Icons.shopping_cart,
                text: "Cmd",
              ),
              GButton(
                icon: Icons.archive,
                text: "Archives",
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
