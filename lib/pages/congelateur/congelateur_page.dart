import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/pages/congelateur/components/boisson_congelee_tile.dart';
import 'package:projet7/pages/detail/boisson/congelee/boisson_congelee_page.dart';
import 'package:projet7/theme/my_colors.dart';
import 'package:provider/provider.dart';

class CongelateurPage extends StatelessWidget {
  const CongelateurPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          "Congélateur",
          style: GoogleFonts.poppins(
            fontSize: 17,
          ),
        ),
      ),
      body: Consumer<Bar>(
        builder: (context, bar, child) => SingleChildScrollView(
          child: Column(
            children: [
              bar.boissonsCongelees.isEmpty
                  ? SizedBox(
                      height: 140.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.inbox,
                              size: 100.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "Aucune boisson congelée",
                            style: GoogleFonts.lato(
                              fontSize: 15.0,
                              color: MyColors.vert,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: bar.boissonsCongelees.length,
                        itemBuilder: (context, index) {
                          final boisson =
                              bar.boissonsCongelees.reversed.toList()[index];
                          return BoissonCongeleeTile(
                            boisson: boisson,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BoissonCongeleePage(boisson: boisson),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
