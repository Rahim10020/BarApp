import 'package:flutter/material.dart';
import 'package:projet7/components/search_field.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/utils/helpers.dart';

class BoissonSection extends StatefulWidget {
  final TextEditingController nomController;
  final TextEditingController prixController;
  final TextEditingController descriptionController;
  final Modele? modele;
  final bool estFroid;
  final ValueChanged<Modele?> onModeleChanged;
  final ValueChanged<bool> onEstFroidChanged;
  final VoidCallback onAjouter;
  final List<Boisson> boissons;
  final ValueChanged<Boisson> onDelete;

  const BoissonSection({
    super.key,
    required this.nomController,
    required this.prixController,
    required this.descriptionController,
    required this.modele,
    required this.estFroid,
    required this.onModeleChanged,
    required this.onEstFroidChanged,
    required this.onAjouter,
    required this.boissons,
    required this.onDelete,
  });

  @override
  State<BoissonSection> createState() => _BoissonSectionState();
}

class _BoissonSectionState extends State<BoissonSection> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredBoissons = widget.boissons.where((boisson) {
      final nom = boisson.nom?.toLowerCase() ?? '';
      return nom.contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            title: Text(
              'Gérer les Boissons',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: Icon(
              Icons.local_drink,
              color: Theme.of(context).colorScheme.primary,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: widget.nomController,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: widget.prixController,
                      decoration: InputDecoration(
                        labelText: 'Prix (CFA)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: widget.descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Modele>(
                      value: widget.modele,
                      decoration: InputDecoration(
                        labelText: 'Modèle',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      items: Modele.values
                          .map((modele) => DropdownMenuItem<Modele>(
                                value: modele,
                                child: Text(
                                    modele == Modele.petit ? 'Petit' : 'Grand'),
                              ))
                          .toList(),
                      onChanged: widget.onModeleChanged,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.local_drink,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      label: Text(
                        'Ajouter Boisson',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      onPressed: widget.onAjouter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Boissons Existantes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SearchField(
                  hintText: 'Rechercher une boisson...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                if (widget.boissons.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Aucune boisson disponible',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                else if (filteredBoissons.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Aucun résultat trouvé pour la recherche',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  ...filteredBoissons.map((boisson) => ListTile(
                        title: Text(
                          boisson.nom != null
                              ? '${boisson.nom} (${boisson.getModele()})'
                              : 'Sans nom (${boisson.getModele()})',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Prix: ${Helpers.formatterEnCFA(boisson.prix.last)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.primary,
                              size: 16,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BoissonDetailScreen(boisson: boisson),
                            ),
                          );
                        },
                      )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
