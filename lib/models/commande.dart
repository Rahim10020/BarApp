import 'package:hive/hive.dart';
import 'package:projet7/models/bar_instance.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/ligne_commande.dart';

part 'commande.g.dart';

/// Modèle représentant un carnet de Commande

@HiveType(typeId: 5)
class Commande {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double montantTotal;

  @HiveField(2)
  final DateTime dateCommande;

  @HiveField(3)
  final List<LigneCommande> lignesCommande;

  @HiveField(4)
  final BarInstance barInstance;

  @HiveField(5)
  final Fournisseur fournisseur;

  /// [id] : repésente la référence de la commande
  /// [montantTotal] : représente le montant total de la commande
  /// [dateCommande] : représente la date où l'opération de commande a été réalisée
  /// [lignesCommande] : représente les différentes lignes dans le carnet de commande
  /// [barInstance] : repésente le bar qui a effectué la commande
  /// [fournisseur] : repésente le fournisseur de la commande
  Commande({
    required this.id,
    required this.montantTotal,
    required this.dateCommande,
    required this.lignesCommande,
    required this.barInstance,
    required this.fournisseur,
  });

  double getPrixTotal() {
    double prixTotal = 0.0;

    for (LigneCommande ligneCommande in lignesCommande) {
      prixTotal += ligneCommande.montant;
    }

    return prixTotal;
  }
}
