import 'package:projet7/domain/repositories/i_bar_repository.dart';
import 'package:projet7/domain/usecases/get_statistics_usecase.dart';
import 'package:projet7/domain/entities/commande.dart';
import 'package:projet7/domain/entities/vente.dart';
import 'package:projet7/data/services/pdf_service.dart';

/// Use case pour générer les rapports PDF de l'application.
///
/// Permet de créer des PDF pour les commandes, les ventes et les statistiques.
/// Utilise [PdfService] pour la génération effective des documents.
///
/// Les fichiers sont sauvegardés dans le dossier Downloads.
class GeneratePdfUseCase {
  final IBarRepository barRepository;
  final GetStatisticsUseCase getStatisticsUseCase;

  GeneratePdfUseCase({
    required this.barRepository,
    required this.getStatisticsUseCase,
  });

  /// Génère un PDF de commande
  Future<String> generateCommandePdf(Commande commande) async {
    final barName = barRepository.getCurrentBar()?.nom ?? "Bar Inconnu";
    return PdfService.generateCommandePdf(commande, barName);
  }

  /// Génère un PDF de vente
  Future<String> generateVentePdf(Vente vente) async {
    final barName = barRepository.getCurrentBar()?.nom ?? "Bar Inconnu";
    return PdfService.generateVentePdf(vente, barName);
  }

  /// Génère un PDF de statistiques
  Future<String> generateStatisticsPdf({
    required DateTime startDate,
    required DateTime endDate,
    String period = 'daily',
  }) async {
    final barName = barRepository.getCurrentBar()?.nom ?? "Bar";

    final stats = getStatisticsUseCase.execute(
      startDate: startDate,
      endDate: endDate,
      period: period,
    );

    return PdfService.generateStatisticsPdf(
      startDate,
      endDate,
      period,
      barName,
      stats.revenueByDrink,
      stats.topSellingDrinks,
      stats.inventoryLevels,
      stats.totalRevenue,
      stats.totalOrders,
      stats.averageOrderValue,
      stats.totalOrderCost,
    );
  }
}
