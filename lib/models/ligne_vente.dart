import 'package:hive/hive.dart';
import 'package:projet7/models/boisson.dart';

part 'ligne_vente.g.dart';

/// Modèle représentant une ligne individuelle dans un carnet de vente.
///
/// Cette classe est persistée dans Hive avec le typeId 2.
/// Chaque ligne de vente correspond à une boisson vendue avec son montant.
/// Plusieurs lignes de vente composent une [Vente] complète.
///
/// Exemple d'utilisation :
/// ```dart
/// final ligneVente = LigneVente(
///   id: 1,
///   montant: 500.0,
///   boisson: maBoisson,
/// );
/// ```
@HiveType(typeId: 2)
class LigneVente {
  /// Identifiant unique de la ligne de vente.
  @HiveField(0)
  final int id;

  /// Montant de la vente pour cette ligne en FCFA.
  ///
  /// Ce montant correspond au prix de la boisson au moment de la vente.
  /// Il peut être synchronisé avec le prix actuel via [synchroniserMontant].
  @HiveField(1)
  double montant;

  /// Boisson concernée par cette ligne de vente.
  ///
  /// Contient toutes les informations sur le produit vendu.
  @HiveField(2)
  final Boisson boisson;

  /// Crée une nouvelle instance de [LigneVente].
  ///
  /// [id] : identifiant unique de la ligne de vente (requis)
  /// [montant] : montant de la vente en FCFA (requis)
  /// [boisson] : boisson vendue (requis)
  LigneVente({
    required this.id,
    required this.montant,
    required this.boisson,
  });

  /// Retourne le montant actuel de la boisson.
  ///
  /// Utilise le dernier prix de la liste des prix de la boisson.
  /// Ce montant peut différer du [montant] stocké si les prix ont changé.
  double getMontant() {
    return boisson.prix.last;
  }

  /// Synchronise le montant stocké avec le prix actuel de la boisson.
  ///
  /// Utile pour mettre à jour le montant après une modification
  /// des prix dans l'inventaire.
  void synchroniserMontant() {
    montant = boisson.prix.last;
  }
}
