import 'package:flutter/material.dart';
import 'package:projet7/components/search_field.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/pages/fournisseur/fournisseur_detail_screen.dart';

class FournisseurSection extends StatefulWidget {
  final TextEditingController nomController;
  final TextEditingController adresseController;
  final VoidCallback onAjouter;
  final List<Fournisseur> fournisseurs;
  final ValueChanged<Fournisseur> onDelete;

  const FournisseurSection({
    super.key,
    required this.nomController,
    required this.adresseController,
    required this.onAjouter,
    required this.fournisseurs,
    required this.onDelete,
  });

  @override
  State<FournisseurSection> createState() => _FournisseurSectionState();
}

class _FournisseurSectionState extends State<FournisseurSection> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredFournisseurs = widget.fournisseurs.where((fournisseur) {
      final nom = fournisseur.nom.toLowerCase();
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
              'Gérer les Fournisseurs',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: Icon(
              Icons.store,
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
                      controller: widget.adresseController,
                      decoration: InputDecoration(
                        labelText: 'Adresse (email/téléphone)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.store,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      label: Text(
                        'Ajouter Fournisseur',
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
                  'Fournisseurs Existants',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SearchField(
                  hintText: 'Rechercher un fournisseur...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                if (widget.fournisseurs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Aucun fournisseur disponible',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                else if (filteredFournisseurs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Aucun résultat trouvé pour la recherche',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  ...filteredFournisseurs.map((fournisseur) => ListTile(
                        title: Text(
                          fournisseur.nom,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(fournisseur.adresse ?? 'Aucun contact'),
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
                              builder: (context) => FournisseurDetailScreen(
                                  fournisseur: fournisseur),
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
