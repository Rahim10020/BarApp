import 'package:projet7/models/bar_instance.dart';

/// Repository pour la configuration du bar
abstract class IBarRepository {
  /// Récupère l'instance du bar actuel
  BarInstance? getCurrentBar();

  /// Crée un nouveau bar
  Future<void> createBar(String nom, String adresse);

  /// Met à jour les informations du bar
  Future<void> updateBar(BarInstance bar);

  /// Vérifie si un bar existe
  bool hasBar();
}
