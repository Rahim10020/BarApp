import 'package:flutter/material.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/pages/commande/components/commande_form.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:provider/provider.dart';

/// Écran pour ajouter une nouvelle commande
class AjouterCommandeScreen extends StatefulWidget {
  const AjouterCommandeScreen({super.key});

  @override
  State<AjouterCommandeScreen> createState() => _AjouterCommandeScreenState();
}

class _AjouterCommandeScreenState extends State<AjouterCommandeScreen> {
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
        Navigator.of(context).pop(true); // Retourner true pour indiquer succès
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une commande'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 600
                ? ThemeConstants.maxWidthForm
                : constraints.maxWidth - ThemeConstants.pagePadding.horizontal;

            return Center(
              child: SingleChildScrollView(
                padding: ThemeConstants.pagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      final offset = (1 - value) * 24;
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, offset),
                          child: child,
                        ),
                      );
                    },
                    child: CommandeForm(
                      provider: provider,
                      casiersSelectionnes: _casiersSelectionnes,
                      nomFournisseurController: _nomFournisseurController,
                      adresseFournisseurController:
                          _adresseFournisseurController,
                      fournisseurSelectionne: _fournisseurSelectionne,
                      onFournisseurChanged: (value) =>
                          setState(() => _fournisseurSelectionne = value),
                      onAjouterCommande: () => _ajouterCommande(provider),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
