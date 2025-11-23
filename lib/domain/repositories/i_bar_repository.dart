import 'package:projet7/models/bar_instance.dart';

/// Repository pour la configuration et l'identification du bar.
///
/// Cette interface gère l'instance unique du bar dans l'application.
/// Elle n'étend pas [IBaseRepository] car il ne peut y avoir qu'un seul bar.
///
/// Le bar doit être créé lors de la première utilisation de l'application.
abstract class IBarRepository {
  /// Récupère l'instance du bar actuel.
  ///
  /// Retourne `null` si aucun bar n'a été configuré.
  BarInstance? getCurrentBar();

  /// Crée un nouveau bar avec les informations fournies.
  ///
  /// [nom] : nom commercial du bar.
  /// [adresse] : coordonnées de contact (téléphone, email, etc.).
  ///
  /// Cette méthode génère automatiquement un ID unique.
  Future<void> createBar(String nom, String adresse);

  /// Met à jour les informations du bar existant.
  ///
  /// [bar] : instance du bar avec les nouvelles valeurs.
  Future<void> updateBar(BarInstance bar);

  /// Vérifie si un bar a été configuré.
  ///
  /// Retourne `true` si un bar existe, `false` sinon.
  /// Utilisé pour déterminer s'il faut afficher l'écran de création.
  bool hasBar();
}
