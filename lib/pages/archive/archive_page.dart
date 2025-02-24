import 'package:flutter/material.dart';
import 'package:projet7/pages/archive/components/boisson_archive.dart';
import 'package:projet7/pages/archive/components/casier_archive.dart';
import 'package:projet7/pages/archive/components/my_tab_bar.dart';
import 'package:projet7/pages/archive/components/vente_tile_archive.dart';
import 'package:projet7/models/bar.dart';
import 'package:provider/provider.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: MyTabBar(tabController: _tabController),
        ),
      ),
      body: Consumer<Bar>(
        builder: (context, bar, child) => TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemCount: bar.ventes.length,
              itemBuilder: (context, index) {
                return VenteTileArchive(
                  vente: bar.ventes.reversed.toList()[index],
                );
              },
            ),
            ListView.builder(
              itemCount: bar.casiers.length,
              itemBuilder: (context, index) {
                return CasierArchive(
                  casier: bar.casiers.reversed.toList()[index],
                );
              },
            ),
            ListView.builder(
              itemCount: bar.boissons.length,
              itemBuilder: (context, index) {
                return BoissonArchive(
                  boisson: bar.boissons.reversed.toList()[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
