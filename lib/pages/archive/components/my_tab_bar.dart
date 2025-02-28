import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/theme/my_Colors.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        dividerColor: Colors.transparent,
        labelColor: MyColors.vert,
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        indicatorColor: MyColors.vert,
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
        ],
      ),
    );
  }
}
