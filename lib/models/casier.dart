import 'package:hive/hive.dart';

import 'boisson.dart';

part 'casier.g.dart';

@HiveType(typeId: 1)
class Casier {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final Boisson boisson;

  @HiveField(2)
  late int quantiteBoisson;

  @HiveField(3)
  final DateTime dateCreation;

  @HiveField(4)
  DateTime? dateModification;

  Casier({
    required this.id,
    required this.boisson,
    required this.quantiteBoisson,
    required this.dateCreation,
    this.dateModification,
  });

  double get prixTotal {
    return boisson.prix.last * quantiteBoisson;
  }
}
