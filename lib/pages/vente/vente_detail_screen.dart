import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/vente/ligne_vente_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class VenteDetailScreen extends StatefulWidget {
  final Vente vente;

  const VenteDetailScreen({super.key, required this.vente});

  @override
  State<VenteDetailScreen> createState() => _VenteDetailScreenState();
}

class _VenteDetailScreenState extends State<VenteDetailScreen> {
  String? _pdfPath; // Stocker le chemin du PDF généré

  Future<void> _downloadAndOpenPdf(BarProvider provider) async {
    try {
      String filePath = await provider.generateVentePdf(widget.vente);
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
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible d\'ouvrir le PDF : ${result.message}',
              style: GoogleFonts.montserrat(),
            ),
          ),
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
        text: 'Voici la vente #${widget.vente.id}',
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
          'Vente #${widget.vente.id}',
          style: GoogleFonts.montserrat(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInfoCard(
              label: 'Montant Total',
              value: Helpers.formatterEnCFA(widget.vente.montantTotal),
            ),
            BuildInfoCard(
              label: 'Date',
              value: Helpers.formatterDate(widget.vente.dateVente),
            ),
            const SizedBox(height: 16),
            Text(
              'Boissons vendues:',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.vente.lignesVente.length,
                itemBuilder: (context, index) {
                  var ligne = widget.vente.lignesVente[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                      title: Text(
                        '${ligne.boisson.nom} (${ligne.boisson.modele?.name})',
                        style: GoogleFonts.montserrat(),
                      ),
                      subtitle: Text(
                        'Montant: ${Helpers.formatterEnCFA(ligne.montant)}',
                        style: GoogleFonts.montserrat(),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LigneVenteDetailScreen(
                            ligneVente: widget.vente.lignesVente[index],
                          ),
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
