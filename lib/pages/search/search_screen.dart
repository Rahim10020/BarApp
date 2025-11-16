import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/pages/commande/commande_detail_screen.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_detail_screen.dart';
import 'package:projet7/pages/vente/vente_detail_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche Globale', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.brown[600],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher (nom, ID, etc.)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(
                    child: Text(
                      'Entrez un terme de recherche',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      if (matchingBoissons.isNotEmpty) ...[
                        _buildSectionHeader(
                            'Boissons (${matchingBoissons.length})'),
                        ...matchingBoissons
                            .map((boisson) => _buildBoissonTile(boisson)),
                      ],
                      if (matchingCasiers.isNotEmpty) ...[
                        _buildSectionHeader(
                            'Casiers (${matchingCasiers.length})'),
                        ...matchingCasiers
                            .map((casier) => _buildCasierTile(casier)),
                      ],
                      if (matchingCommandes.isNotEmpty) ...[
                        _buildSectionHeader(
                            'Commandes (${matchingCommandes.length})'),
                        ...matchingCommandes
                            .map((commande) => _buildCommandeTile(commande)),
                      ],
                      if (matchingVentes.isNotEmpty) ...[
                        _buildSectionHeader(
                            'Ventes (${matchingVentes.length})'),
                        ...matchingVentes
                            .map((vente) => _buildVenteTile(vente)),
                      ],
                      if (matchingRefrigerateurs.isNotEmpty) ...[
                        _buildSectionHeader(
                            'Réfrigérateurs (${matchingRefrigerateurs.length})'),
                        ...matchingRefrigerateurs.map((refrigerateur) =>
                            _buildRefrigerateurTile(refrigerateur)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.brown[100],
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
        ),
      ),
    );
  }

  Widget _buildBoissonTile(Boisson boisson) {
    return ListTile(
      leading: Icon(Icons.wine_bar, color: Colors.brown[600]),
      title: Text(boisson.nom ?? 'Sans nom', style: GoogleFonts.montserrat()),
      subtitle: Text('Prix: ${Helpers.formatterEnCFA(boisson.prix.last)}',
          style: GoogleFonts.montserrat()),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BoissonDetailScreen(boisson: boisson),
        ),
      ),
    );
  }

  Widget _buildCasierTile(Casier casier) {
    return ListTile(
      leading: Icon(Icons.storage, color: Colors.brown[600]),
      title: Text('Casier #${casier.id}', style: GoogleFonts.montserrat()),
      subtitle: Text('${casier.boissons.length} boissons',
          style: GoogleFonts.montserrat()),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CasierDetailScreen(casier: casier),
        ),
      ),
    );
  }

  Widget _buildCommandeTile(Commande commande) {
    return ListTile(
      leading: Icon(Icons.receipt, color: Colors.brown[600]),
      title: Text('Commande #${commande.id}', style: GoogleFonts.montserrat()),
      subtitle: Text(
        'Total: ${Helpers.formatterEnCFA(commande.montantTotal)} - ${Helpers.formatterDate(commande.dateCommande)}',
        style: GoogleFonts.montserrat(),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommandeDetailScreen(commande: commande),
        ),
      ),
    );
  }

  Widget _buildVenteTile(Vente vente) {
    return ListTile(
      leading: Icon(Icons.local_drink, color: Colors.brown[600]),
      title: Text('Vente #${vente.id}', style: GoogleFonts.montserrat()),
      subtitle: Text(
        'Total: ${Helpers.formatterEnCFA(vente.montantTotal)} - ${Helpers.formatterDate(vente.dateVente)}',
        style: GoogleFonts.montserrat(),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VenteDetailScreen(vente: vente),
        ),
      ),
    );
  }

  Widget _buildRefrigerateurTile(Refrigerateur refrigerateur) {
    return ListTile(
      leading: Icon(Icons.kitchen, color: Colors.brown[600]),
      title: Text('Réfrigérateur #${refrigerateur.id}',
          style: GoogleFonts.montserrat()),
      subtitle: Text('${refrigerateur.boissons?.length ?? 0} boissons',
          style: GoogleFonts.montserrat()),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              RefrigerateurDetailScreen(refrigerateur: refrigerateur),
        ),
      ),
    );
  }
}
