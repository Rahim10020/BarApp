import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/pages/commande/ligne_commande_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CommandeDetailScreen extends StatefulWidget {
  final Commande commande;

  const CommandeDetailScreen({super.key, required this.commande});

  @override
  State<CommandeDetailScreen> createState() => _CommandeDetailScreenState();
}

class _CommandeDetailScreenState extends State<CommandeDetailScreen> {
  String? _pdfPath; // Stocker le chemin du PDF généré

  Future<void> _downloadAndOpenPdf(BarProvider provider) async {
    try {
      String filePath = await provider.generateCommandePdf(widget.commande);
      setState(() {
        _pdfPath = filePath; // Stocker le chemin du PDF
      });
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'PDF ouvert avec succès !',
            style: GoogleFonts.montserrat(),
          )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Impossible d\'ouvrir le PDF : ${result.message}',
            style: GoogleFonts.montserrat(),
          )),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la génération du PDF : $e',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez d\'abord générer le PDF',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
      return;
    }
    try {
      await Share.shareXFiles(
        [XFile(_pdfPath!)],
        text: 'Voici la commande #${widget.commande.id}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors du partage : $e',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);

    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            'Commande #${widget.commande.id}',
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInfoCard(label: 'ID', value: '${widget.commande.id}'),
            BuildInfoCard(
                label: 'Montant Total',
                value: Helpers.formatterEnCFA(widget.commande.montantTotal)),
            BuildInfoCard(
              label: 'Date',
              value: Helpers.formatterDate(widget.commande.dateCommande),
            ),
            BuildInfoCard(label: 'Bar', value: widget.commande.barInstance.nom),
            BuildInfoCard(
                label: 'Fournisseur',
                value: widget.commande.fournisseur != null
                    ? widget.commande.fournisseur!.nom
                    : "Inconnu"),
            const SizedBox(height: 16),
            Text(
              'Lignes de commande:',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.commande.lignesCommande.length,
                itemBuilder: (context, index) {
                  var ligne = widget.commande.lignesCommande[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.storage, color: Colors.brown[600]),
                      title: Text(
                        'Casier #${ligne.casier.id}',
                      ),
                      subtitle: Text(
                        'Montant: ${Helpers.formatterEnCFA(ligne.montant)} - Boissons: ${ligne.casier.boissonTotal}',
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LigneCommandeDetailScreen(
                              ligneCommande:
                                  widget.commande.lignesCommande[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: Text(
                    'Télécharger',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                  ),
                  onPressed: () => _downloadAndOpenPdf(provider),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: Text(
                    'Partager',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                  ),
                  onPressed: _pdfPath != null ? _sharePdf : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
