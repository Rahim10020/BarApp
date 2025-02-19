// import 'package:isar/isar.dart';

// part 'boisson.g.dart';

// @Collection()
// class Boisson {
//   Id id = Isar.autoIncrement;
//   late String nom;
//   @enumerated // Convertit automatiquement l'énumération en int
//   late Modele modele;
//   late double prix;
//   late int casiers;
//   late int nbBouteilleParCasier;

//   // ✅ Constructeur sans paramètre requis par Isar
//   Boisson();

//   // Méthode pour calculer le prix total de la boisson dans un casier
//   double calculerPrixPourCasier() {
//     return prix * nbBouteilleParCasier;
//   }

//   // Méthode pour calculer le prix total de la boisson pour tous ses casiers
//   double calculerPrixPourTousCasier() {
//     return casiers * calculerPrixPourCasier();
//   }
// }

// // Enumération pour représenter la taille de la boisson
// enum Modele { petit, grand }
