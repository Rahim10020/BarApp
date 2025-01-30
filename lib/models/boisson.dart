class Boisson {
  final String nom;
  final Modele
      modele; // soit la boisson en question est petite soit elle est grande
  double prix;
  int casiers; // nombre total de casiers disponibles pour cette boisson
  int nbBouteilleParCasier; // nombre de bouteilles dans un casier de cette boisson

  Boisson({
    required this.nom,
    required this.modele,
    required this.prix,
    required this.casiers,
    required this.nbBouteilleParCasier,
  });

  // methode qui me calcule le prix total de la boisson dans un casier
  double calculerPrixPourCasier() {
    return prix * nbBouteilleParCasier;
  }

  // methode qui me permet de calculer le prix total de la boisson pour tous ses casiers
  double calculerPrixPourTousCasier() {
    return casiers * calculerPrixPourCasier();
  }
}

enum Modele { petit, grand }
