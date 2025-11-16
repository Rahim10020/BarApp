import 'package:flutter/material.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/pages/commande/commande_detail_screen.dart';
import 'package:projet7/pages/commande/components/commande_form.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

/// Écran de gestion des commandes
class CommandeScreen extends StatefulWidget {
  const CommandeScreen({super.key});

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  final List<Casier> _casiersSelectionnes = [];
  final _nomFournisseurController = TextEditingController();
  final _adresseFournisseurController = TextEditingController();
  Fournisseur? _fournisseurSelectionne;

  @override
  void dispose() {
    _nomFournisseurController.dispose();
    _adresseFournisseurController.dispose();
    super.dispose();
  }

  Future<void> _ajouterCommande(BarAppProvider provider) async {
    // Validation
    if (_casiersSelectionnes.isEmpty) {
      context
          .showWarningSnackBar('La commande doit concerner au moins un casier');
      return;
    }

    if (_fournisseurSelectionne == null &&
        _nomFournisseurController.text.trim().isEmpty) {
      context
          .showWarningSnackBar('Veuillez sélectionner ou créer un fournisseur');
      return;
    }

    try {
      Fournisseur? fournisseur;

      // Créer un nouveau fournisseur si le nom est renseigné
      if (_nomFournisseurController.text.trim().isNotEmpty) {
        fournisseur = Fournisseur(
          id: await provider.generateUniqueId("Fournisseur"),
          nom: _nomFournisseurController.text.trim(),
          adresse: _adresseFournisseurController.text.trim(),
        );
        await provider.addFournisseur(fournisseur);
      } else {
        fournisseur = _fournisseurSelectionne;
      }

      // Créer les lignes de commande
      final lignes = _casiersSelectionnes.asMap().entries.map((e) {
        final casier = e.value;
        final ligne = LigneCommande(
          id: e.key,
          montant: casier.getPrixTotal(),
          casier: casier,
        );
        ligne.synchroniserMontant();
        return ligne;
      }).toList();

      // Créer la commande
      final commande = Commande(
        id: await provider.generateUniqueId("Commande"),
        montantTotal: lignes.fold(0.0, (sum, ligne) => sum + ligne.montant),
        dateCommande: DateTime.now(),
        lignesCommande: lignes,
        barInstance: provider.currentBar!,
        fournisseur: fournisseur,
      );

      await provider.addCommande(commande);

      if (mounted) {
        setState(() {
          _casiersSelectionnes.clear();
          _nomFournisseurController.clear();
          _adresseFournisseurController.clear();
          _fournisseurSelectionne = null;
        });
        context
            .showSuccessSnackBar('Commande #${commande.id} créée avec succès');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Padding(
      padding: ThemeConstants.pagePadding,
      child: Column(
        children: [
          CommandeForm(
            provider: provider,
            casiersSelectionnes: _casiersSelectionnes,
            nomFournisseurController: _nomFournisseurController,
            adresseFournisseurController: _adresseFournisseurController,
            fournisseurSelectionne: _fournisseurSelectionne,
            onFournisseurChanged: (value) =>
                setState(() => _fournisseurSelectionne = value),
            onAjouterCommande: () => _ajouterCommande(provider),
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Liste des commandes
          Expanded(
            child: provider.commandes.isEmpty
                ? Center(
                    child: AppCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: ThemeConstants.iconSize3Xl,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: ThemeConstants.spacingMd),
                          Text(
                            'Aucune commande',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: ThemeConstants.spacingXs),
                          Text(
                            'Créez votre première commande ci-dessus',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: provider.commandes.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: ThemeConstants.spacingSm),
                    itemBuilder: (context, index) {
                      final commande = provider.commandes[index];
                      return _CommandeListItem(
                        commande: commande,
                        provider: provider,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Item de liste pour une commande
class _CommandeListItem extends StatelessWidget {
  final Commande commande;
  final BarAppProvider provider;

  const _CommandeListItem({
    required this.commande,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommandeDetailScreen(commande: commande),
        ),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.expense.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.expense,
              size: ThemeConstants.iconSizeLg,
            ),
          ),

          const SizedBox(width: ThemeConstants.spacingMd),

          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID et Fournisseur
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacingXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(ThemeConstants.radiusSm),
                      ),
                      child: Text(
                        '#${commande.id}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (commande.fournisseur != null) ...[
                      const SizedBox(width: ThemeConstants.spacingXs),
                      Flexible(
                        child: Text(
                          commande.fournisseur!.nom,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: ThemeConstants.spacingXs),

                // Montant et Date
                Row(
                  children: [
                    Text(
                      Helpers.formatterEnCFA(commande.montantTotal),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.expense,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      ' • ${Helpers.formatterDate(commande.dateCommande)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Supprimer
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: AppColors.error,
              size: ThemeConstants.iconSizeMd,
            ),
            onPressed: () async {
              final confirmed = await AppDialogs.showDeleteDialog(
                context,
                title: 'Supprimer la commande',
                message:
                    'Voulez-vous vraiment supprimer la commande #${commande.id} ?',
              );

              if (confirmed == true && context.mounted) {
                try {
                  await provider.deleteCommande(commande);
                  if (context.mounted) {
                    context.showSuccessSnackBar(
                        'Commande #${commande.id} supprimée');
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorSnackBar('Erreur: ${e.toString()}');
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
