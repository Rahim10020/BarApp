import 'package:hive/hive.dart';

import 'boisson.dart';

part 'casier.g.dart';

/// Modèle représentant un casier de boissons.
///
/// Cette classe est persistée dans Hive avec le typeId 1.
/// Un casier est un conteneur physique regroupant plusieurs boissons
/// du même type, utilisé pour la gestion de l'inventaire et les commandes.
///
/// Exemple d'utilisation :
/// ```dart
/// final casier = Casier(
///   id: 1,
///   boissonTotal: 24,
///   boissons: [boisson1, boisson2, ...],
/// );
/// print('Prix total: ${casier.getPrixTotal()} FCFA');
/// ```
@HiveType(typeId: 1)
class Casier {
  /// Identifiant unique du casier.
  @HiveField(0)
  final int id;

  /// Nombre total de boissons que peut contenir le casier.
  ///
  /// Cette valeur peut être différente du nombre actuel de boissons
  /// dans la liste [boissons] si le casier n'est pas plein.
  @HiveField(2)
  late int boissonTotal;

  /// Liste des boissons contenues dans le casier.
  ///
  /// Chaque élément représente une boisson individuelle.
  /// La taille de cette liste peut varier selon le remplissage du casier.
  @HiveField(3)
  List<Boisson> boissons;

  /// Crée une nouvelle instance de [Casier].
  ///
  /// [id] : identifiant unique du casier (requis)
  /// [boissonTotal] : capacité totale du casier (requis)
  /// [boissons] : liste des boissons dans le casier (requis)
  Casier({
    required this.id,
    required this.boissonTotal,
    required this.boissons,
  });

  /// Calcule le prix total de toutes les boissons dans le casier.
  ///
  /// Additionne le dernier prix de chaque boisson (généralement le prix grand).
  ///
  /// Retourne le prix total en FCFA.
  double getPrixTotal() {
    double prixTotal = 0.0;

    for (Boisson boisson in boissons) {
      prixTotal += boisson.prix.last;
    }

    return prixTotal;
  }
}
