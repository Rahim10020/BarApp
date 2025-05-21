import 'package:flutter/material.dart';
import 'package:projet7/components/search_field.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';

class CasierSection extends StatefulWidget {
  final Boisson? boissonSelectionnee;
  final TextEditingController quantiteController;
  final ValueChanged<Boisson?> onBoissonChanged;
  final VoidCallback onAjouter;
  final List<Casier> casiers;
  final List<Boisson> boissons;
  final ValueChanged<Casier> onDelete;

  const CasierSection({
    super.key,
    required this.boissonSelectionnee,
    required this.quantiteController,
    required this.onBoissonChanged,
    required this.onAjouter,
    required this.casiers,
    required this.boissons,
    required this.onDelete,
  });

  @override
  State<CasierSection> createState() => _CasierSectionState();
}

class _CasierSectionState extends State<CasierSection> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCasiers = widget.casiers.where((casier) {
      final nomBoisson = casier.boissons.isNotEmpty
          ? casier.boissons.first.nom?.toLowerCase() ?? ''
          : '';
      final id = casier.id.toString();
      return nomBoisson.contains(_searchQuery.toLowerCase()) ||
          id.contains(_searchQuery);
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
              'Gérer les Casiers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: Icon(
              Icons.storage,
              color: Theme.of(context).colorScheme.primary,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<Boisson>(
                      value: widget.boissonSelectionnee,
                      decoration: InputDecoration(
                        labelText: 'Boisson',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      items: widget.boissons
                          .map((boisson) => DropdownMenuItem<Boisson>(
                                value: boisson,
                                child: Text(
                                  boisson.nom != null
                                      ? '${boisson.nom} (${boisson.getModele()})'
                                      : 'Sans nom (${boisson.getModele()})',
                                ),
                              ))
                          .toList(),
                      onChanged: widget.onBoissonChanged,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: widget.quantiteController,
                      decoration: InputDecoration(
                        labelText: 'Quantité',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.storage,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      label: Text(
                        'Ajouter Casier',
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
                  'Casiers Existants',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SearchField(
                  hintText: 'Rechercher un casier...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                if (widget.casiers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Aucun casier disponible',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                else if (filteredCasiers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Aucun résultat trouvé pour la recherche',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  ...filteredCasiers.map((casier) => ListTile(
                        title: Text(
                          'Casier #${casier.id}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(casier.boissons.isNotEmpty
                            ? '${casier.boissonTotal} x ${casier.boissons.first.nom ?? 'Sans nom'}'
                            : 'Vide'),
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
                                  CasierDetailScreen(casier: casier),
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
