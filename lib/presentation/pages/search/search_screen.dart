import 'package:flutter/material.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/domain/entities/casier.dart';
import 'package:projet7/domain/entities/commande.dart';
import 'package:projet7/domain/entities/refrigerateur.dart';
import 'package:projet7/domain/entities/vente.dart';
import 'package:projet7/presentation/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/presentation/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/presentation/pages/commande/commande_detail_screen.dart';
import 'package:projet7/presentation/pages/refrigerateur/refrigerateur_detail_screen.dart';
import 'package:projet7/presentation/pages/vente/vente_detail_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/app_typography.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/inputs/app_text_field.dart';
import 'package:projet7/core/utils/helpers.dart';
import 'package:provider/provider.dart';

/// Écran de recherche globale dans l'application.
///
/// Permet de rechercher parmi toutes les entités de l'application:
/// - Boissons (par nom)
/// - Casiers (par ID)
/// - Commandes (par ID ou nom de fournisseur)
/// - Ventes (par ID ou nom de boisson)
/// - Réfrigérateurs (par ID)
///
/// Les résultats sont affichés par catégorie avec navigation vers les détails.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    // Search results
    final matchingBoissons = provider.boissons
        .where((b) => (b.nom ?? '').toLowerCase().contains(_searchQuery))
        .toList();

    final matchingCasiers = provider.casiers
        .where((c) => c.id.toString().contains(_searchQuery))
        .toList();

    final matchingCommandes = provider.commandes
        .where((c) =>
            c.id.toString().contains(_searchQuery) ||
            c.fournisseur?.nom.toLowerCase().contains(_searchQuery) == true)
        .toList();

    final matchingVentes = provider.ventes
        .where((v) =>
            v.id.toString().contains(_searchQuery) ||
            v.lignesVente.any((l) =>
                (l.boisson.nom ?? '').toLowerCase().contains(_searchQuery)))
        .toList();

    final matchingRefrigerateurs = provider.refrigerateurs
        .where((r) => r.id.toString().contains(_searchQuery))
        .toList();

    final hasResults = matchingBoissons.isNotEmpty ||
        matchingCasiers.isNotEmpty ||
        matchingCommandes.isNotEmpty ||
        matchingVentes.isNotEmpty ||
        matchingRefrigerateurs.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recherche',
          style: AppTypography.pageTitle(context),
        ),
      ),
      body: Column(
        children: [
          // Champ de recherche
          Padding(
            padding: ThemeConstants.pagePadding,
            child: AppSearchField(
              controller: _searchController,
              hint: 'Rechercher (nom, ID, fournisseur...)',
              autofocus: true,
            ),
          ),

          // Résultats
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildEmptyState(
                    context,
                    'Entrez un terme de recherche',
                    Icons.search_rounded,
                  )
                : !hasResults
                    ? _buildEmptyState(
                        context,
                        'Aucun résultat pour "$_searchQuery"',
                        Icons.search_off_rounded,
                      )
                    : ListView(
                        padding: const EdgeInsets.only(
                          bottom: ThemeConstants.spacingXl,
                        ),
                        children: [
                          if (matchingBoissons.isNotEmpty)
                            _buildSection(
                              context,
                              'Boissons',
                              matchingBoissons.length,
                              Icons.wine_bar_rounded,
                              AppColors.warmDrink,
                              matchingBoissons
                                  .map((b) => _buildBoissonTile(b))
                                  .toList(),
                            ),
                          if (matchingCasiers.isNotEmpty)
                            _buildSection(
                              context,
                              'Casiers',
                              matchingCasiers.length,
                              Icons.inventory_2_rounded,
                              AppColors.stockAvailable,
                              matchingCasiers
                                  .map((c) => _buildCasierTile(c))
                                  .toList(),
                            ),
                          if (matchingCommandes.isNotEmpty)
                            _buildSection(
                              context,
                              'Commandes',
                              matchingCommandes.length,
                              Icons.receipt_long_rounded,
                              AppColors.expense,
                              matchingCommandes
                                  .map((c) => _buildCommandeTile(c))
                                  .toList(),
                            ),
                          if (matchingVentes.isNotEmpty)
                            _buildSection(
                              context,
                              'Ventes',
                              matchingVentes.length,
                              Icons.point_of_sale_rounded,
                              AppColors.revenue,
                              matchingVentes
                                  .map((v) => _buildVenteTile(v))
                                  .toList(),
                            ),
                          if (matchingRefrigerateurs.isNotEmpty)
                            _buildSection(
                              context,
                              'Réfrigérateurs',
                              matchingRefrigerateurs.length,
                              Icons.kitchen_rounded,
                              AppColors.coldDrink,
                              matchingRefrigerateurs
                                  .map((r) => _buildRefrigerateurTile(r))
                                  .toList(),
                            ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: ThemeConstants.iconSize2Xl,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: ThemeConstants.spacingMd),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    int count,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: ThemeConstants.spacingMd),
          // Header de section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingXs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ThemeConstants.iconSizeSm,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingSm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: ThemeConstants.spacingXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacingSm,
                  vertical: ThemeConstants.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(ThemeConstants.radiusFull),
                ),
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacingSm),
          // Liste des résultats
          ...children,
        ],
      ),
    );
  }

  Widget _buildBoissonTile(Boisson boisson) {
    return AppCard(
      padding: const EdgeInsets.all(ThemeConstants.spacingSm),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BoissonDetailScreen(boisson: boisson),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.warmDrink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
            child: const Icon(
              Icons.wine_bar_rounded,
              color: AppColors.warmDrink,
              size: ThemeConstants.iconSizeSm,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boisson.nom ?? 'Sans nom',
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Helpers.formatterEnCFA(boisson.prix.last),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.revenue,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: ThemeConstants.iconSizeSm,
          ),
        ],
      ),
    );
  }

  Widget _buildCasierTile(Casier casier) {
    return AppCard(
      padding: const EdgeInsets.all(ThemeConstants.spacingSm),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CasierDetailScreen(casier: casier),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.stockAvailable.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: AppColors.stockAvailable,
              size: ThemeConstants.iconSizeSm,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Casier #${casier.id}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${casier.boissons.length} boissons',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: ThemeConstants.iconSizeSm,
          ),
        ],
      ),
    );
  }

  Widget _buildCommandeTile(Commande commande) {
    return AppCard(
      padding: const EdgeInsets.all(ThemeConstants.spacingSm),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommandeDetailScreen(commande: commande),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.expense.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.expense,
              size: ThemeConstants.iconSizeSm,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commande #${commande.id}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${Helpers.formatterEnCFA(commande.montantTotal)} • ${Helpers.formatterDateCourt(commande.dateCommande)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: ThemeConstants.iconSizeSm,
          ),
        ],
      ),
    );
  }

  Widget _buildVenteTile(Vente vente) {
    return AppCard(
      padding: const EdgeInsets.all(ThemeConstants.spacingSm),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VenteDetailScreen(vente: vente),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.revenue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
            child: const Icon(
              Icons.point_of_sale_rounded,
              color: AppColors.revenue,
              size: ThemeConstants.iconSizeSm,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vente #${vente.id}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${Helpers.formatterEnCFA(vente.montantTotal)} • ${Helpers.formatterDateCourt(vente.dateVente)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: ThemeConstants.iconSizeSm,
          ),
        ],
      ),
    );
  }

  Widget _buildRefrigerateurTile(Refrigerateur refrigerateur) {
    return AppCard(
      padding: const EdgeInsets.all(ThemeConstants.spacingSm),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              RefrigerateurDetailScreen(refrigerateur: refrigerateur),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.coldDrink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
            child: const Icon(
              Icons.kitchen_rounded,
              color: AppColors.coldDrink,
              size: ThemeConstants.iconSizeSm,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Réfrigérateur #${refrigerateur.id}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${refrigerateur.boissons?.length ?? 0} boissons',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: ThemeConstants.iconSizeSm,
          ),
        ],
      ),
    );
  }
}
