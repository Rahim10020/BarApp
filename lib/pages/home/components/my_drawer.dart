import 'package:flutter/material.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.wine_bar,
                  size: 50,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  provider.currentBar?.nom ?? 'Bar',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.wine_bar,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Changer de bar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    'Changer de bar',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  content: provider.bars.isEmpty
                      ? Text(
                          'Aucun bar disponible',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: provider.bars
                              .map(
                                (bar) => ListTile(
                                  title: Text(
                                    bar.nom,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  onTap: () {
                                    provider.currentBar = bar;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                ),
              );
            },
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Paramètres',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Page des paramètres non implémentée',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Déconnexion',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Fonction de déconnexion non implémentée',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
