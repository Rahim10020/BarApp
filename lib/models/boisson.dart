import 'package:hive/hive.dart';
import 'package:projet7/models/modele.dart';

part 'boisson.g.dart';

@HiveType(typeId: 0)
class Boisson {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String? nom;

  @HiveField(2)
  Modele? modele;

  @HiveField(3)
  bool estFroid;

  @HiveField(4)
  final List<double> prix;

  @HiveField(5)
  String? description;

  @HiveField(6)
  final String imagePath;

  Boisson({
    required this.id,
    this.nom,
    this.modele,
    this.estFroid = false,
    required this.prix,
    this.description,
    required this.imagePath,
  });

  String? getModele() {
    switch (modele) {
      case Modele.petit:
        return "Petit";
      case Modele.grand:
        return "Grand";
      case null:
        return null;
    }
  }
}
