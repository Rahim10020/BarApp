import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

class BoissonDetailSansModifScreen extends StatefulWidget {
  final Boisson boisson;

  const BoissonDetailSansModifScreen({super.key, required this.boisson});

  @override
  State<BoissonDetailSansModifScreen> createState() =>
      _BoissonDetailSansModifScreenState();
}

class _BoissonDetailSansModifScreenState
    extends State<BoissonDetailSansModifScreen> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  Modele? _modele;
  bool _estFroid = false;

  @override
  void initState() {
    super.initState();
    _nomController.text = widget.boisson.nom ?? '';
    _prixController.text = widget.boisson.prix.last.toString();
    _descriptionController.text = widget.boisson.description ?? '';
    _modele = widget.boisson.modele;
    _estFroid = widget.boisson.estFroid;
  }

  void _modifierBoisson(BarProvider provider) async {
    if (_nomController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le nom de la boisson");
    } else if (_prixController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le prix");
    } else {
      try {
        final prix = double.parse(_prixController.text);
        final boissonModifiee = Boisson(
          id: widget.boisson.id,
          nom: _nomController.text,
          prix: [prix], // Remplace la liste des prix
          estFroid: _estFroid,
          modele: _modele,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
        );
        final boissonIndex =
            provider.boissons.indexWhere((b) => b.id == widget.boisson.id);
        if (boissonIndex != -1) {
          await provider.updateBoisson(boissonModifiee);
        } else {
          await provider.addBoisson(boissonModifiee);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Boisson modifiée avec succès !',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog(context, "Erreur : $e");
      }
    }
  }

  void _supprimerBoisson(BarProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Supprimer la boisson',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ${widget.boisson.nom} ?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteBoisson(widget.boisson);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Boisson supprimée avec succès !',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
              );
            },
            child: Text(
              'Supprimer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }

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
              'OK',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          widget.boisson.nom ?? 'Boisson',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      widget.boisson.estFroid ? Icons.ac_unit : Icons.local_bar,
                      size: 80,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildInfoCard(
                        label: 'Nom',
                        value: widget.boisson.nom ?? 'N/A',
                      ),
                      BuildInfoCard(
                        label: 'Prix',
                        value: Helpers.formatterEnCFA(widget.boisson.prix.last),
                      ),
                      BuildInfoCard(
                        label: 'Froide',
                        value: widget.boisson.estFroid ? 'Oui' : 'Non',
                      ),
                      BuildInfoCard(
                        label: 'Modèle',
                        value: widget.boisson.getModele() ?? 'N/A',
                      ),
                      BuildInfoCard(
                        label: 'Description',
                        value: widget.boisson.description ?? 'Aucune',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
