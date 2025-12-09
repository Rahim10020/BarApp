import 'package:flutter/material.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/domain/entities/modele.dart';
import 'package:projet7/presentation/pages/detail/boisson/components/boisson_form.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:provider/provider.dart';

/// Écran pour ajouter une nouvelle boisson
class AjouterBoissonScreen extends StatefulWidget {
  const AjouterBoissonScreen({super.key});

  @override
  State<AjouterBoissonScreen> createState() => _AjouterBoissonScreenState();
}

class _AjouterBoissonScreenState extends State<AjouterBoissonScreen> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  Modele? _modele;

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _ajouterBoisson(BarAppProvider provider) async {
    // Validation
    if (_nomController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner le nom');
      return;
    }

    if (_prixController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner le prix');
      return;
    }

    if (_modele == null) {
      context.showWarningSnackBar('Veuillez choisir le modèle');
      return;
    }

    // Vérifier que le prix est valide
    final prix = double.tryParse(_prixController.text.trim());
    if (prix == null || prix <= 0) {
      context.showErrorSnackBar('Le prix doit être un nombre positif');
      return;
    }

    try {
      final boisson = Boisson(
        id: await provider.generateUniqueId("Boisson"),
        nom: _nomController.text.trim(),
        prix: [prix],
        estFroid: false,
        modele: _modele,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
      );

      await provider.addBoisson(boisson);

      if (mounted) {
        Navigator.of(context).pop(true); // Retourner true pour indiquer succès
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur: ${e.toString()}');
      }
    }
  }

  void _resetForm() {
    _nomController.clear();
    _prixController.clear();
    _descriptionController.clear();
    setState(() => _modele = null);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une boisson'),
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
                    child: BoissonForm(
                      provider: provider,
                      nomController: _nomController,
                      prixController: _prixController,
                      descriptionController: _descriptionController,
                      selectedModele: _modele,
                      onModeleChanged: (value) =>
                          setState(() => _modele = value),
                      onAjouterBoisson: () => _ajouterBoisson(provider),
                      onResetForm: _resetForm,
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
