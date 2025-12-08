import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet7/presentation/pages/refrigerateur/ajouter_refrigerateur_screen.dart';
import 'package:projet7/presentation/pages/refrigerateur/components/refrigerateur_list_item.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:provider/provider.dart';

/// Écran de gestion des réfrigérateurs
class RefrigerateurScreen extends StatefulWidget {
  const RefrigerateurScreen({super.key});

  @override
  State<RefrigerateurScreen> createState() => _RefrigerateurScreenState();
}

class _RefrigerateurScreenState extends State<RefrigerateurScreen> {
  Future<void> _navigateToAjouterRefrigerateur() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AjouterRefrigerateurScreen()),
    );

    if (result == true && mounted) {
      // Le réfrigérateur a été ajouté avec succès
      // Le provider se mettra à jour automatiquement
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Scaffold(
      body: Padding(
        padding: ThemeConstants.pagePadding,
        child: Column(
          children: [
            // Liste des réfrigérateurs
            Expanded(
              child: provider.refrigerateurs.isEmpty
                  ? Center(
                      child: AppCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/fridge.svg',
                              width: ThemeConstants.iconSize3Xl,
                              height: ThemeConstants.iconSize3Xl,
                            ),
                            const SizedBox(height: ThemeConstants.spacingMd),
                            Text(
                              'Aucun réfrigérateur',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: ThemeConstants.spacingXs),
                            Text(
                              'Appuyez sur le bouton + pour ajouter un réfrigérateur',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: provider.refrigerateurs.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: ThemeConstants.spacingSm),
                      itemBuilder: (context, index) {
                        final refrigerateur = provider.refrigerateurs[index];
                        return RefrigerateurListItem(
                          refrigerateur: refrigerateur,
                          provider: provider,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAjouterRefrigerateur,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
        heroTag: 'ajouter-refrigerateur',
      ),
    );
  }
}
