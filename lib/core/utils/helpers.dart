import 'package:intl/intl.dart';
import 'package:projet7/domain/entities/modele.dart';

/// Classe utilitaire contenant des fonctions d'aide pour le formatage.
///
/// Fournit des méthodes statiques pour :
/// - Conversion entre enum [Modele] et chaînes de caractères
/// - Formatage des montants en FCFA (Franc CFA)
/// - Formatage des dates au format français
class Helpers {
  /// Convertit une chaîne en enum [Modele].
  ///
  /// [modele] : "Petit" ou "Grand".
  /// Retourne [Modele.grand] par défaut si la chaîne n'est pas reconnue.
  static Modele getModele(String modele) {
    switch (modele) {
      case "Petit":
        return Modele.petit;
      case "Grand":
        return Modele.grand;
    }
    return Modele.grand;
  }

  /// Convertit un enum [Modele] en chaîne lisible.
  ///
  /// [modele] : l'enum à convertir.
  /// Retourne "Petit", "Grand" ou `null` si le modèle est null.
  static String? getModeleToString(Modele? modele) {
    switch (modele) {
      case Modele.petit:
        return "Petit";
      case Modele.grand:
        return "Grand";
      case null:
        return null;
    }
  }

  /// Formate un montant en devise FCFA (Franc CFA).
  ///
  /// [montant] : le montant à formater.
  /// Retourne une chaîne formatée (ex: "1 500 FCFA").
  ///
  /// Utilise la locale française pour le formatage des nombres.
  static String formatterEnCFA(double montant) {
    return NumberFormat.currency(
            locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
        .format(montant);
  }

  /// Formate une date au format français avec heure.
  ///
  /// [date] : la date à formater.
  /// Retourne une chaîne au format "JJ/MM/AAAA à HH:MM".
  ///
  /// Exemple : "25/12/2024 à 14:30"
  static String formatterDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()} à ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
  }

  /// Formate une date au format court.
  ///
  /// [date] : la date à formater.
  /// Retourne une chaîne au format "JJ/MM/AA".
  ///
  /// Exemple : "25/12/24"
  static String formatterDateCourt(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
  }

  /// Retourne le chemin de l'icône appropriée pour une boisson.
  ///
  /// [nom] : le nom de la boisson.
  /// Retourne 'assets/icons/fanta-youki2.svg' pour Fanta, Youki et Coca Cola,
  /// 'assets/icons/boissons.svg' pour les autres boissons.
  static String getBoissonIconPath(String? nom) {
    if (nom == null) return 'assets/icons/boissons.svg';
    final lowerNom = nom.toLowerCase();
    if (lowerNom.contains('fanta') ||
        lowerNom.contains('youki') ||
        lowerNom.contains('coca')) {
      return 'assets/icons/fanta-youki2.svg';
    }
    return 'assets/icons/boissons.svg';
  }

  /// Retourne le chemin de l'icône pour les casiers.
  ///
  /// Retourne toujours 'assets/icons/casier.svg'.
  static String getCasierIconPath() {
    return 'assets/icons/casier.svg';
  }
}
