import 'package:hive/hive.dart';
import 'package:projet7/domain/entities/ligne_vente.dart';

part 'vente.g.dart';

/// Modèle représentant une transaction de vente complète.
///
/// Cette classe est persistée dans Hive avec le typeId 4.
/// Une vente regroupe plusieurs lignes de vente ([LigneVente]) et
/// représente une transaction commerciale complète avec sa date et son montant total.
///
/// Exemple d'utilisation :
/// ```dart
/// final vente = Vente(
///   id: 1,
///   montantTotal: 2500.0,
///   dateVente: DateTime.now(),
///   lignesVente: [ligneVente1, ligneVente2],
/// );
/// ```
@HiveType(typeId: 4)
class Vente {
  /// Identifiant unique de la vente.
  ///
  /// Sert de référence pour retrouver la transaction.
  @HiveField(0)
  final int id;

  /// Montant total de la vente en FCFA.
  ///
  /// Correspond à la somme de tous les montants des lignes de vente.
  @HiveField(1)
  final double montantTotal;

  /// Date et heure de la transaction de vente.
  ///
  /// Utilisée pour les rapports et statistiques de ventes.
  @HiveField(2)
  final DateTime dateVente;

  /// Liste des lignes composant cette vente.
  ///
  /// Chaque ligne représente un article vendu avec son montant.
  @HiveField(3)
  final List<LigneVente> lignesVente;

  /// Crée une nouvelle instance de [Vente].
  ///
  /// [id] : identifiant unique de la vente (requis)
  /// [montantTotal] : montant total en FCFA (requis)
  /// [dateVente] : date de la transaction (requis)
  /// [lignesVente] : liste des lignes de vente (requis)
  Vente({
    required this.id,
    required this.montantTotal,
    required this.dateVente,
    required this.lignesVente,
  });

  /// Calcule le prix total en additionnant les montants de chaque ligne.
  ///
  /// Peut différer de [montantTotal] si les prix des boissons ont été modifiés
  /// après la création de la vente.
  ///
  /// Retourne le total calculé en FCFA.
  double getPrixTotal() {
    double prixTotal = 0.0;

    for (LigneVente ligneVente in lignesVente) {
      prixTotal += ligneVente.montant;
    }

    return prixTotal;
  }
}
