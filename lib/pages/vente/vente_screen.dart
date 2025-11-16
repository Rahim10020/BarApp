import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/vente/components/vente_form.dart';
import 'package:projet7/pages/vente/components/vente_list_item.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';
import 'package:provider/provider.dart';

/// Écran de vente redesigné avec design system
class VenteScreen extends StatefulWidget {
  const VenteScreen({super.key});

  @override
  State<VenteScreen> createState() => _VenteScreenState();
}

class _VenteScreenState extends State<VenteScreen> {
  List<Boisson> boissonsSelectionnees = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Ajouter une vente avec feedback UX moderne
  Future<void> _ajouterVente(BarAppProvider provider) async {
    if (boissonsSelectionnees.isEmpty) {
      context.showWarningSnackBar('Veuillez sélectionner des boissons');
      return;
    }

    setState(() => _isAdding = true);

    try {
      // Créer les lignes de vente
      final lignes = boissonsSelectionnees.asMap().entries.map((e) {
        final ligne = LigneVente(
          id: e.key,
          montant: e.value.prix.last,
          boisson: e.value,
        );
        ligne.synchroniserMontant();
        return ligne;
      }).toList();

      // Créer la vente
      final vente = Vente(
        id: await provider.generateUniqueId("Vente"),
        montantTotal: lignes.fold(0.0, (sum, ligne) => sum + ligne.montant),
        dateVente: DateTime.now(),
        lignesVente: lignes,
      );

      await provider.addVente(vente);

      // Retirer les boissons vendues des réfrigérateurs
      for (final refrigerateur in provider.refrigerateurs) {
        refrigerateur.boissons
            ?.removeWhere((b) => boissonsSelectionnees.contains(b));
        await provider.updateRefrigerateur(refrigerateur);
      }

      // Attendre un court délai pour l'animation
      await Future.delayed(ThemeConstants.durationNormal);

      if (mounted) {
        setState(() {
          boissonsSelectionnees.clear();
          _isAdding = false;
        });
        context.showSuccessSnackBar('Vente enregistrée avec succès !');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAdding = false);
        context.showErrorSnackBar('Erreur lors de l\'enregistrement: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    // Limiter les boissons disponibles à celles des réfrigérateurs
    final boissonsDisponibles =
        provider.refrigerateurs.expand((r) => r.boissons ?? []).toList();

    // ✅ FIX: Filtrer une seule fois (pas deux fois comme avant)
    final searchQuery = _searchController.text.toLowerCase();
    final ventesFiltered = searchQuery.isEmpty
        ? provider.ventes.toList()
        : provider.ventes.where((v) {
            return v.id.toString().contains(searchQuery) ||
                v.dateVente.toString().toLowerCase().contains(searchQuery) ||
                v.lignesVente.any((l) =>
                    (l.boisson.nom ?? '')
                        .toLowerCase()
                        .contains(searchQuery));
          }).toList();

    return Padding(
      padding: ThemeConstants.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // === FORMULAIRE DE VENTE ===
          VenteForm(
            provider: provider,
            boissonsSelectionnees: boissonsSelectionnees,
            isAdding: _isAdding,
            onAjouterVente: () => _ajouterVente(provider),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // === RECHERCHE ===
          AppSearchField(
            controller: _searchController,
            hint: 'Rechercher par ID, date ou boisson...',
            onChanged: (_) {}, // Le setState est dans initState
          ),

          SizedBox(height: ThemeConstants.spacingMd),

          // === LISTE DES VENTES ===
          Expanded(
            child: ventesFiltered.isEmpty
                ? _buildEmptyState(context, searchQuery.isNotEmpty)
                : ListView.separated(
                    itemCount: ventesFiltered.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: ThemeConstants.spacingSm),
                    itemBuilder: (context, index) {
                      final vente = ventesFiltered[index];
                      return VenteListItem(
                        vente: vente,
                        provider: provider,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// État vide (aucune vente)
  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.receipt_long_rounded,
            size: ThemeConstants.iconSize2Xl,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: ThemeConstants.spacingMd),
          Text(
            isSearching ? 'Aucun résultat' : 'Aucune vente',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: ThemeConstants.spacingXs),
          Text(
            isSearching
                ? 'Essayez avec d\'autres mots-clés'
                : 'Créez votre première vente ci-dessus',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
