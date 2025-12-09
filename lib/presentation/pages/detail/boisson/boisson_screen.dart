import 'package:flutter/material.dart';
import 'package:projet7/presentation/pages/detail/boisson/ajouter_boisson_screen.dart';
import 'package:projet7/presentation/pages/detail/boisson/components/boisson_list_item.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:provider/provider.dart';

/// Écran de gestion des boissons
class BoissonScreen extends StatefulWidget {
  const BoissonScreen({super.key});

  @override
  State<BoissonScreen> createState() => _BoissonScreenState();
}

class _BoissonScreenState extends State<BoissonScreen> {
  Future<void> _navigateToAjouterBoisson() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AjouterBoissonScreen()),
    );

    if (result == true && mounted) {
      // La boisson a été ajoutée avec succès
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
            // Liste des boissons
            Expanded(
              child: provider.boissons.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        child: AppCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_bar_outlined,
                                size: ThemeConstants.iconSize3Xl,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: ThemeConstants.spacingMd),
                              Text(
                                'Aucune boisson',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: ThemeConstants.spacingXs),
                              Text(
                                'Appuyez sur le bouton + pour ajouter une boisson',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: provider.boissons.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: ThemeConstants.spacingSm),
                      itemBuilder: (context, index) {
                        final boisson = provider.boissons[index];
                        return BoissonListItem(
                          boisson: boisson,
                          provider: provider,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAjouterBoisson,
        icon: const Icon(Icons.add),
        heroTag: 'ajouter-boisson',
        label: const SizedBox.shrink(),
      ),
    );
  }
}
