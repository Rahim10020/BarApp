import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/vente/ligne_vente_detail_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

/// Écran de détail d'une vente avec génération PDF
class VenteDetailScreen extends StatefulWidget {
  final Vente vente;

  const VenteDetailScreen({super.key, required this.vente});

  @override
  State<VenteDetailScreen> createState() => _VenteDetailScreenState();
}

class _VenteDetailScreenState extends State<VenteDetailScreen> {
  String? _pdfPath;
  bool _isGeneratingPdf = false;

  Future<void> _downloadAndOpenPdf(BarAppProvider provider) async {
    setState(() => _isGeneratingPdf = true);

    try {
      final filePath = await provider.generateVentePdf(widget.vente);

      if (mounted) {
        setState(() {
          _pdfPath = filePath;
          _isGeneratingPdf = false;
        });
      }

      final result = await OpenFile.open(filePath);

      if (result.type == ResultType.done) {
        if (mounted) {
          context.showSuccessSnackBar('PDF ouvert avec succès');
        }
      } else {
        if (mounted) {
          context.showErrorSnackBar(
              'Impossible d\'ouvrir le PDF : ${result.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
        context.showErrorSnackBar('Erreur : $e');
      }
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfPath == null) {
      if (mounted) {
        context.showWarningSnackBar('Veuillez d\'abord générer le PDF');
      }
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(_pdfPath!)],
        text: 'Vente #${widget.vente.id}',
      );
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur lors du partage : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vente #${widget.vente.id}'),
      ),
      body: Padding(
        padding: ThemeConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec montant total
            AppCard(
              color: AppColors.revenue.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.revenue.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(ThemeConstants.radiusMd),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.revenue,
                      size: ThemeConstants.iconSizeXl,
                    ),
                  ),
                  const SizedBox(width: ThemeConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Montant Total',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          Helpers.formatterEnCFA(widget.vente.montantTotal),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppColors.revenue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingMd),

            // Date
            AppCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.primary,
                    size: ThemeConstants.iconSizeMd,
                  ),
                  const SizedBox(width: ThemeConstants.spacingMd),
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Text(
                    Helpers.formatterDate(widget.vente.dateVente),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingLg),

            // Titre de la section
            Text(
              'Boissons vendues',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: ThemeConstants.spacingMd),

            // Liste des lignes de vente
            Expanded(
              child: widget.vente.lignesVente.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            size: ThemeConstants.iconSize3Xl,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: ThemeConstants.spacingMd),
                          Text(
                            'Aucune boisson',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: widget.vente.lignesVente.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: ThemeConstants.spacingSm),
                      itemBuilder: (context, index) {
                        final ligne = widget.vente.lignesVente[index];
                        return AppCard(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LigneVenteDetailScreen(
                                ligneVente: ligne,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                    ThemeConstants.spacingSm),
                                decoration: BoxDecoration(
                                  color: AppColors.coldDrink
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                      ThemeConstants.radiusSm),
                                ),
                                child: const Icon(
                                  Icons.local_bar_rounded,
                                  color: AppColors.coldDrink,
                                  size: ThemeConstants.iconSizeMd,
                                ),
                              ),
                              const SizedBox(width: ThemeConstants.spacingMd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${ligne.boisson.nom} (${ligne.boisson.modele?.name})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(
                                        height: ThemeConstants.spacingXs),
                                    Text(
                                      Helpers.formatterEnCFA(ligne.montant),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.revenue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: ThemeConstants.spacingMd),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(
                    text: 'Télécharger PDF',
                    icon: Icons.download_rounded,
                    isLoading: _isGeneratingPdf,
                    onPressed: () => _downloadAndOpenPdf(provider),
                  ),
                ),
                const SizedBox(width: ThemeConstants.spacingMd),
                Expanded(
                  child: AppButton.secondary(
                    text: 'Partager',
                    icon: Icons.share_rounded,
                    onPressed: _pdfPath != null ? _sharePdf : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
