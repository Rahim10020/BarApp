import 'package:hive/hive.dart';
import 'package:projet7/domain/entities/casier.dart';

part 'ligne_commande.g.dart';

/// Modèle représentant une ligne individuelle dans un bon de commande.
///
/// Cette classe est persistée dans Hive avec le typeId 3.
/// Chaque ligne de commande correspond à un casier commandé avec son montant.
/// Plusieurs lignes de commande composent une [Commande] complète.
///
/// Exemple d'utilisation :
/// ```dart
/// final ligneCommande = LigneCommande(
///   id: 1,
///   montant: 12000.0,
///   casier: monCasier,
/// );
/// ```
@HiveType(typeId: 3)
class LigneCommande {
  /// Identifiant unique de la ligne de commande.
  @HiveField(0)
  final int id;

  /// Montant de la commande pour cette ligne en FCFA.
  ///
  /// Ce montant correspond au prix total du casier au moment de la commande.
  /// Il peut être synchronisé avec le prix actuel via [synchroniserMontant].
  @HiveField(1)
  double montant;

  /// Casier concerné par cette ligne de commande.
  ///
  /// Contient les boissons commandées et leurs informations.
  @HiveField(2)
  final Casier casier;

  /// Crée une nouvelle instance de [LigneCommande].
  ///
  /// [id] : identifiant unique de la ligne de commande (requis)
  /// [montant] : montant total du casier en FCFA (requis)
  /// [casier] : casier commandé (requis)
  LigneCommande({
    required this.id,
    required this.montant,
    required this.casier,
  });

  /// Retourne le montant actuel calculé du casier.
  ///
  /// Ce montant peut différer du [montant] stocké si les prix ont changé.
  double getMontant() {
    return casier.getPrixTotal();
  }

  /// Synchronise le montant stocké avec le prix total actuel du casier.
  ///
  /// Utile pour mettre à jour le montant après une modification
  /// des prix dans l'inventaire.
  void synchroniserMontant() {
    montant = casier.getPrixTotal();
  }
}
