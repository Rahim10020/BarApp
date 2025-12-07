import 'package:flutter/material.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/services/boisson_import_service.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:provider/provider.dart';

/// Écran d'import des boissons avec prévisualisation
class BoissonImportScreen extends StatefulWidget {
  const BoissonImportScreen({super.key});

  @override
  State<BoissonImportScreen> createState() => _BoissonImportScreenState();
}

class _BoissonImportScreenState extends State<BoissonImportScreen> {
  final BoissonImportService _importService = BoissonImportService();
  List<BoissonImport>? _boissonsToImport;
  bool _isLoading = false;
  Set<int> _selectedIndices = {};
  bool _selectAll = true;

  @override
  void initState() {
    super.initState();
    _loadDefaultBoissons();
  }

  Future<void> _loadDefaultBoissons() async {
    setState(() => _isLoading = true);

    try {
      final boissons = await _importService.loadDefaultBoissons();
      setState(() {
        _boissonsToImport = boissons;
        // Sélectionner toutes les boissons par défaut
        _selectedIndices = Set.from(List.generate(boissons.length, (i) => i));
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur de chargement: ${e.toString()}');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _importSelectedBoissons() async {
    if (_selectedIndices.isEmpty) {
      context.showWarningSnackBar('Veuillez sélectionner au moins une boisson');
      return;
    }

    final provider = Provider.of<BarAppProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      int importedCount = 0;

      for (int index in _selectedIndices) {
        final boissonImport = _boissonsToImport![index];
        final id = await provider.generateUniqueId("Boisson");
        final boisson = boissonImport.toBoisson(id);
        await provider.addBoisson(boisson);
        importedCount++;
      }

      if (mounted) {
        context.showSuccessSnackBar(
          '$importedCount boisson${importedCount > 1 ? 's' : ''} importée${importedCount > 1 ? 's' : ''} avec succès !',
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur d\'import: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
      _selectAll = _selectedIndices.length == _boissonsToImport?.length;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectAll) {
        _selectedIndices.clear();
        _selectAll = false;
      } else {
        _selectedIndices = Set.from(
          List.generate(_boissonsToImport?.length ?? 0, (i) => i),
        );
        _selectAll = true;
      }
    });
  }

  String _formatPrix(List<double> prix) {
    if (prix.isEmpty) return '0 FCFA';
    if (prix.length == 1) return '${prix[0].toInt()} FCFA';
    return '${prix[0].toInt()} - ${prix[1].toInt()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Importer des boissons', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          if (_boissonsToImport != null && _boissonsToImport!.isNotEmpty)
            IconButton(
              icon: Icon(_selectAll ? Icons.deselect : Icons.select_all),
              onPressed: _toggleSelectAll,
              tooltip: _selectAll ? 'Tout désélectionner' : 'Tout sélectionner',
            ),
        ],
      ),
      body: _isLoading && _boissonsToImport == null
          ? const Center(child: CircularProgressIndicator())
          : _boissonsToImport == null || _boissonsToImport!.isEmpty
              ? _buildEmptyState()
              : _buildBoissonsList(),
      bottomNavigationBar: _boissonsToImport != null && _boissonsToImport!.isNotEmpty
          ? _buildBottomBar()
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: ThemeConstants.pagePadding,
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                size: ThemeConstants.iconSize3Xl,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: ThemeConstants.spacingMd),
              Text(
                'Aucune boisson à importer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: ThemeConstants.spacingSm),
              Text(
                'Le fichier de boissons par défaut est vide ou invalide',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoissonsList() {
    return Column(
      children: [
        // En-tête
        Container(
          padding: ThemeConstants.pagePadding,
          color: AppColors.primary.withValues(alpha: 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: ThemeConstants.iconSizeMd,
                  ),
                  const SizedBox(width: ThemeConstants.spacingSm),
                  Expanded(
                    child: Text(
                      'Sélectionnez les boissons à importer',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeConstants.spacingXs),
              Text(
                '${_selectedIndices.length} / ${_boissonsToImport!.length} sélectionnée(s)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // Liste des boissons
        Expanded(
          child: ListView.separated(
            padding: ThemeConstants.pagePadding,
            itemCount: _boissonsToImport!.length,
            separatorBuilder: (_, __) => const SizedBox(height: ThemeConstants.spacingSm),
            itemBuilder: (context, index) {
              final boisson = _boissonsToImport![index];
              final isSelected = _selectedIndices.contains(index);

              return AppCard(
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (_) => _toggleSelection(index),
                  activeColor: AppColors.primary,
                  title: Text(
                    boisson.nom,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: ThemeConstants.spacingXs),
                      Row(
                        children: [
                          Icon(
                            Icons.payments_rounded,
                            size: ThemeConstants.iconSizeSm,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: ThemeConstants.spacingXs),
                          Text(
                            _formatPrix(boisson.prix),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      if (boisson.modele != null) ...[
                        const SizedBox(height: ThemeConstants.spacingXs),
                        Row(
                          children: [
                            Icon(
                              Icons.category_rounded,
                              size: ThemeConstants.iconSizeSm,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: ThemeConstants.spacingXs),
                            Text(
                              'Modèle: ${boisson.modele}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                      if (boisson.description != null &&
                          boisson.description!.isNotEmpty) ...[
                        const SizedBox(height: ThemeConstants.spacingXs),
                        Text(
                          boisson.description!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.backgroundLight.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    ),
                    child: Icon(
                      Icons.local_bar_rounded,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: ThemeConstants.pagePadding,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton.primary(
              text: 'Importer (${_selectedIndices.length})',
              icon: Icons.download,
              isFullWidth: true,
              onPressed: _isLoading ? null : _importSelectedBoissons,
              isLoading: _isLoading,
            ),
            const SizedBox(height: ThemeConstants.spacingSm),
            AppButton.secondary(
              text: 'Annuler',
              isFullWidth: true,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}

