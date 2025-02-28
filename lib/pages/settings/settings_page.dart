import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Paramètres",
          style: GoogleFonts.poppins(
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(left: 25, top: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mode sombre",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                // maintenant on va utiliser un switch
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
