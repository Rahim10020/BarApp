import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/utils/helpers.dart';

/// Service de génération de documents PDF.
///
/// Fournit des méthodes statiques pour créer des documents PDF:
/// - [generateCommandePdf] - PDF de détail d'une commande fournisseur
/// - [generateVentePdf] - PDF de détail d'une vente
/// - [generateStatisticsPdf] - Rapport statistique complet avec revenus,
///   ventes populaires et niveaux d'inventaire
///
/// Les PDF sont sauvegardés dans le dossier Téléchargements de l'appareil.
class PdfService {
  static Future<String> generateCommandePdf(
      Commande commande, String barName) async {
    final pdf = pw.Document();

    // Définir les styles
    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown600,
    );
    const infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    const tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // En-tête avec le nom du bar
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.brown100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.brown600, width: 2)),
              ),
              child: pw.Text(
                'Bar: $barName',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),

            // Titre de la commande
            pw.Text('Commande #${commande.id}', style: subHeaderStyle),
            pw.SizedBox(height: 10),

            // Informations générales
            pw.Text('Date: ${Helpers.formatterDate(commande.dateCommande)}',
                style: infoStyle),
            pw.Text(
                'Montant Total: ${Helpers.formatterEnCFA(commande.montantTotal)}',
                style: infoStyle),
            pw.Text(
              'Fournisseur: ${commande.fournisseur != null ? commande.fournisseur!.nom : "Inconnu"}',
              style: infoStyle,
            ),
            pw.SizedBox(height: 20),

            // Section des lignes de commande
            pw.Text('Lignes de Commande:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.brown400),
              children: [
                // En-tête du tableau
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.brown600),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Casier ID', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Boisson', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Nombre de Boissons',
                          style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Montant', style: tableHeaderStyle),
                    ),
                  ],
                ),
                // Lignes de commande
                ...commande.lignesCommande.map((ligne) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Casier #${ligne.casier.id}',
                              style: tableCellStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            ligne.casier.boissons.isNotEmpty
                                ? ligne.casier.boissons[0].nom ?? 'Sans nom'
                                : 'Aucune boisson',
                            style: tableCellStyle,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('${ligne.casier.boissonTotal}',
                              style: tableCellStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              Helpers.formatterEnCFA(ligne.getMontant()),
                              style: tableCellStyle),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );

    // Sauvegarder dans le répertoire "Téléchargements"
    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/commande_${commande.id}.pdf';
    final file = File(filePath);

    // Supprimer l'ancien PDF s'il existe
    if (await file.exists()) {
      await file.delete();
    }

    // Sauvegarder le nouveau PDF
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  static Future<String> generateVentePdf(Vente vente, String barName) async {
    final pdf = pw.Document();

    // Définir les styles
    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown600,
    );
    const infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    const tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // En-tête avec le nom du bar
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.brown100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.brown600, width: 2)),
              ),
              child: pw.Text(
                'Bar: $barName',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),

            // Titre de la vente
            pw.Text('Vente #${vente.id}', style: subHeaderStyle),
            pw.SizedBox(height: 10),

            // Informations générales
            pw.Text('Date: ${Helpers.formatterDate(vente.dateVente)}',
                style: infoStyle),
            pw.Text(
                'Montant Total: ${Helpers.formatterEnCFA(vente.montantTotal)}',
                style: infoStyle),
            pw.SizedBox(height: 20),

            // Section des lignes de vente
            pw.Text('Lignes de Vente:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.brown400),
              children: [
                // En-tête du tableau
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.brown600),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Boisson', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Montant', style: tableHeaderStyle),
                    ),
                  ],
                ),
                // Lignes de vente
                ...vente.lignesVente.map((ligne) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(ligne.boisson.nom ?? 'Sans nom',
                              style: tableCellStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              Helpers.formatterEnCFA(ligne.getMontant()),
                              style: tableCellStyle),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );

    // Sauvegarder dans le répertoire "Téléchargements"
    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/vente_${vente.id}.pdf';
    final file = File(filePath);

    // Supprimer l'ancien PDF s'il existe
    if (await file.exists()) {
      await file.delete();
    }

    // Sauvegarder le nouveau PDF
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  static Future<String> generateStatisticsPdf(
      DateTime startDate,
      DateTime endDate,
      String period,
      String barName,
      Map<String, double> revenueByDrink,
      List<MapEntry<String, int>> topSellingDrinks,
      Map<String, int> inventoryLevels,
      double totalRevenue,
      int totalOrders,
      double averageOrderValue,
      double totalOrderCost) async {
    final pdf = pw.Document();

    // Définir les styles
    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown600,
    );
    const infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    const tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // En-tête
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.brown100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.brown600, width: 2)),
              ),
              child: pw.Text(
                'Rapport Statistique - $barName',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),

            // Période
            pw.Text(
                'Période: ${Helpers.formatterDate(startDate)} - ${Helpers.formatterDate(endDate)}',
                style: infoStyle),
            pw.SizedBox(height: 20),

            // Statistiques générales
            pw.Text('Statistiques Générales:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.brown400),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.brown600),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Métrique', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Valeur', style: tableHeaderStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Revenus totaux', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(Helpers.formatterEnCFA(totalRevenue),
                          style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Nombre de ventes', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('$totalOrders', style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Panier moyen', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(Helpers.formatterEnCFA(averageOrderValue),
                          style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Coûts totaux', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(Helpers.formatterEnCFA(totalOrderCost),
                          style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Bénéfice', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                          Helpers.formatterEnCFA(totalRevenue - totalOrderCost),
                          style: tableCellStyle),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Boissons les plus vendues
            if (topSellingDrinks.isNotEmpty) ...[
              pw.Text('Boissons les plus vendues:', style: subHeaderStyle),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.brown400),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.brown600),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Boisson', style: tableHeaderStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Ventes', style: tableHeaderStyle),
                      ),
                    ],
                  ),
                  ...topSellingDrinks.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(entry.key, style: tableCellStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('${entry.value}',
                                style: tableCellStyle),
                          ),
                        ],
                      )),
                ],
              ),
              pw.SizedBox(height: 20),
            ],

            // Revenus par boisson
            if (revenueByDrink.isNotEmpty) ...[
              pw.Text('Revenus par boisson:', style: subHeaderStyle),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.brown400),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.brown600),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Boisson', style: tableHeaderStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Revenus', style: tableHeaderStyle),
                      ),
                    ],
                  ),
                  ...revenueByDrink.entries.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(entry.key, style: tableCellStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(Helpers.formatterEnCFA(entry.value),
                                style: tableCellStyle),
                          ),
                        ],
                      )),
                ],
              ),
              pw.SizedBox(height: 20),
            ],

            // Niveaux d'inventaire
            if (inventoryLevels.isNotEmpty) ...[
              pw.Text('Niveaux d\'inventaire:', style: subHeaderStyle),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.brown400),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.brown600),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Boisson', style: tableHeaderStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Unités', style: tableHeaderStyle),
                      ),
                    ],
                  ),
                  ...inventoryLevels.entries.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(entry.key, style: tableCellStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('${entry.value}',
                                style: tableCellStyle),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    // Sauvegarder dans le répertoire "Téléchargements"
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      throw Exception('Impossible d\'accéder au répertoire de téléchargements');
    }
    final filePath =
        '${directory.path}/rapport_statistiques_${Helpers.formatterDate(DateTime.now()).replaceAll('/', '-')}.pdf';
    final file = File(filePath);

    // Supprimer l'ancien PDF s'il existe
    if (await file.exists()) {
      await file.delete();
    }

    // Sauvegarder le nouveau PDF
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }
}
