import 'package:hive/hive.dart';
import 'package:projet7/models/bar_instance.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/ligne_commande.dart';

part 'commande.g.dart';

/// Modèle représentant un bon de commande complet auprès d'un fournisseur.
///
/// Cette classe est persistée dans Hive avec le typeId 5.
/// Une commande regroupe plusieurs lignes de commande ([LigneCommande]) et
/// contient les informations sur le bar commanditaire et le fournisseur.
///
/// Exemple d'utilisation :
/// ```dart
/// final commande = Commande(
///   id: 1,
///   montantTotal: 50000.0,
///   dateCommande: DateTime.now(),
///   lignesCommande: [ligneCmd1, ligneCmd2],
///   barInstance: monBar,
///   fournisseur: monFournisseur,
/// );
/// ```
@HiveType(typeId: 5)
class Commande {
  /// Référence unique de la commande.
  ///
  /// Sert d'identifiant pour le suivi et la facturation.
  @HiveField(0)
  final int id;

  /// Montant total de la commande en FCFA.
  ///
  /// Correspond à la somme de tous les montants des lignes de commande.
  @HiveField(1)
  final double montantTotal;

  /// Date et heure de création de la commande.
  ///
  /// Utilisée pour les rapports et le suivi des approvisionnements.
  @HiveField(2)
  final DateTime dateCommande;

  /// Liste des lignes composant cette commande.
  ///
  /// Chaque ligne représente un casier commandé avec son montant.
  @HiveField(3)
  final List<LigneCommande> lignesCommande;

  /// Bar ayant passé la commande.
  ///
  /// Contient les informations d'identification du bar commanditaire.
  @HiveField(4)
  final BarInstance barInstance;

  /// Fournisseur auprès duquel la commande est passée.
  ///
  /// Peut être null si le fournisseur n'est pas encore défini.
  @HiveField(5)
  Fournisseur? fournisseur;

  /// Crée une nouvelle instance de [Commande].
  ///
  /// [id] : référence unique de la commande (requis)
  /// [montantTotal] : montant total en FCFA (requis)
  /// [dateCommande] : date de la commande (requis)
  /// [lignesCommande] : liste des lignes de commande (requis)
  /// [barInstance] : bar commanditaire (requis)
  /// [fournisseur] : fournisseur de la commande
  Commande({
    required this.id,
    required this.montantTotal,
    required this.dateCommande,
    required this.lignesCommande,
    required this.barInstance,
    this.fournisseur,
  });

  /// Calcule le prix total en additionnant les montants de chaque ligne.
  ///
  /// Peut différer de [montantTotal] si les prix ont été modifiés
  /// après la création de la commande.
  ///
  /// Retourne le total calculé en FCFA.
  double getPrixTotal() {
    double prixTotal = 0.0;

    for (LigneCommande ligneCommande in lignesCommande) {
      prixTotal += ligneCommande.montant;
    }

    return prixTotal;
  }
}
