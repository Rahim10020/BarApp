import 'package:isar/isar.dart';
import 'boisson.dart';

part 'casier.g.dart';

@Collection()
class Casier {
  Id id = Isar.autoIncrement;
  final IsarLink<Boisson> boisson =
      IsarLink<Boisson>(); // Relation avec Boisson
  late int nbBouteillesRestantes;

  Casier({
    required this.nbBouteillesRestantes,
  });

  // Constructeur par défaut requis par Isar
  Casier.empty();

  // Méthode pour calculer le prix des boissons restantes
  double prixBoissonRestant() {
    return (boisson.value?.prix ?? 0) * nbBouteillesRestantes;
  }
}
