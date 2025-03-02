import 'package:hive/hive.dart';

part "modele.g.dart";

@HiveType(typeId: 9)
enum Modele {
  @HiveField(0)
  petit,
  @HiveField(1)
  grand,
}
