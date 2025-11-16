import 'package:projet7/domain/repositories/i_bar_repository.dart';
import 'package:projet7/domain/usecases/get_statistics_usecase.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/services/pdf_service.dart';

/// Use case pour générer tous les types de PDF
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
