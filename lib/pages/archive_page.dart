import 'package:flutter/material.dart';
import 'package:projet7/components/casier_archive.dart';
import 'package:projet7/components/my_tab_bar.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const CasierArchive(
                onTap: null,
              );
            },
          ),
          ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const CasierArchive(
                onTap: null,
              );
            },
          ),
        ],
      ),
    );
  }
}
