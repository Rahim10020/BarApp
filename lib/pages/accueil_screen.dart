import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/pages/section/boisson_section.dart';
import 'package:projet7/pages/section/fournisseur_section.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  // Contrôleurs pour les boissons
  final _nomBoissonController = TextEditingController();
  final _prixBoissonController = TextEditingController();
  final _descriptionBoissonController = TextEditingController();
  Modele? _modeleBoisson;
  bool _estFroid = false;

  // Contrôleurs pour les fournisseurs
  final _nomFournisseurController = TextEditingController();
  final _adresseFournisseurController = TextEditingController();

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _ajouterBoisson(BarProvider provider) async {
    if (_nomBoissonController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le nom de la boisson");
    } else if (_prixBoissonController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le prix");
    } else {
      try {
        final prix = double.parse(_prixBoissonController.text);
        final boisson = Boisson(
          id: await provider.generateUniqueId("Boisson"),
          nom: _nomBoissonController.text,
          prix: [prix],
          estFroid: _estFroid,
          modele: _modeleBoisson,
          description: _descriptionBoissonController.text,
        );
        await provider.addBoisson(boisson);
        _nomBoissonController.clear();
        _prixBoissonController.clear();
        _descriptionBoissonController.clear();
        setState(() {
          _modeleBoisson = null;
          _estFroid = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Boisson ajoutée avec succès !',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      } catch (e) {
        _showErrorDialog(context, "Erreur : $e");
      }
    }
  }

  void _ajouterFournisseur(BarProvider provider) async {
    if (_nomFournisseurController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le nom du fournisseur");
    } else {
      final fournisseur = Fournisseur(
        id: await provider.generateUniqueId("Fournisseur"),
        nom: _nomFournisseurController.text,
        adresse: _adresseFournisseurController.text.isNotEmpty
            ? _adresseFournisseurController.text
            : null,
      );
      await provider.addFournisseur(fournisseur);
      _nomFournisseurController.clear();
      _adresseFournisseurController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fournisseur ajouté avec succès !',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Boissons
          BoissonSection(
            nomController: _nomBoissonController,
            prixController: _prixBoissonController,
            descriptionController: _descriptionBoissonController,
            modele: _modeleBoisson,
            estFroid: _estFroid,
            onModeleChanged: (value) => setState(() => _modeleBoisson = value),
            onEstFroidChanged: (value) => setState(() => _estFroid = value),
            onAjouter: () => _ajouterBoisson(provider),
            boissons: provider.boissons,
            onDelete: (boisson) => provider.deleteBoisson(boisson),
          ),
          const SizedBox(height: 16),
          // Section Fournisseurs
          FournisseurSection(
            nomController: _nomFournisseurController,
            adresseController: _adresseFournisseurController,
            onAjouter: () => _ajouterFournisseur(provider),
            fournisseurs: provider.fournisseurs,
            onDelete: (fournisseur) => provider.deleteFournisseur(fournisseur),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomBoissonController.dispose();
    _prixBoissonController.dispose();
    _descriptionBoissonController.dispose();
    _nomFournisseurController.dispose();
    _adresseFournisseurController.dispose();
    super.dispose();
  }
}
