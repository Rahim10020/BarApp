import 'package:flutter/material.dart';
import 'package:projet7/domain/entities/refrigerateur.dart';
import 'package:projet7/presentation/pages/refrigerateur/components/refrigerateur_form.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:provider/provider.dart';

/// Écran pour ajouter un nouveau réfrigérateur
class AjouterRefrigerateurScreen extends StatefulWidget {
  const AjouterRefrigerateurScreen({super.key});

  @override
  State<AjouterRefrigerateurScreen> createState() =>
      _AjouterRefrigerateurScreenState();
}

class _AjouterRefrigerateurScreenState
    extends State<AjouterRefrigerateurScreen> {
  final _nomController = TextEditingController();
  final _tempController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  Future<void> _ajouterRefrigerateur(BarAppProvider provider) async {
    // Validation
    if (_nomController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner le nom');
      return;
    }

    if (_tempController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner la température');
      return;
    }

    // Vérifier que la température est valide
    final temperature = double.tryParse(_tempController.text.trim());
    if (temperature == null) {
      context.showErrorSnackBar('La température doit être un nombre valide');
      return;
    }

    try {
      final refrigerateur = Refrigerateur(
        id: await provider.generateUniqueId("Refrigerateur"),
        nom: _nomController.text.trim(),
        temperature: temperature,
      );

      await provider.addRefrigerateur(refrigerateur);

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
    _tempController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un réfrigérateur'),
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
                    child: RefrigerateurForm(
                      provider: provider,
                      nomController: _nomController,
                      tempController: _tempController,
                      onAjouterRefrigerateur: () =>
                          _ajouterRefrigerateur(provider),
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
