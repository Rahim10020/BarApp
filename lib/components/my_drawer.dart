import 'package:flutter/material.dart';
import 'package:projet7/authentication/login_or_register.dart';
import 'package:projet7/components/my_drawer_tile.dart';
import 'package:projet7/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // logo de l'application
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Icon(
              Icons.shop,
              size: 50,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          // ensuite le divider
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          // ensuite home
          MyDrawerTile(
            text: "HOME",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          // ensuite les parametres
          MyDrawerTile(
            text: "PARAMETRES",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          // on met ensuite un espace
          const Spacer(),
          // ensuite se deconnecter ou quiter
          MyDrawerTile(
            text: "QUITTER",
            icon: Icons.logout,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegister(),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
