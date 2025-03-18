import 'package:hive/hive.dart';
import 'modele.dart';

part 'boisson.g.dart';

@HiveType(typeId: 0)
class Boisson extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String? nom;

  @HiveField(2)
  List<double> prix;

  @HiveField(3)
  bool estFroid;

  @HiveField(4)
  Modele? modele;

  @HiveField(5)
  String? description;

  Boisson({
    required this.id,
    this.nom,
    required this.prix,
    required this.estFroid,
    this.modele,
    this.description,
  });

  String? getModele() => modele == Modele.petit
      ? 'Petit'
      : modele == Modele.grand
          ? 'Grand'
          : null;
}
