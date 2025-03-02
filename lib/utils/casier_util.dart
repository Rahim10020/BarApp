import 'package:projet7/models/casier.dart';

class CasierUtil {
  static List<Casier> trierCasierParPrix(List<Casier> casiers) {
    List<Casier> casiersParPrix = List.from(casiers);
    casiersParPrix.sort(
      (a, b) => a.getPrixTotal().compareTo(b.getPrixTotal()),
    );
    return casiersParPrix;
  }

  static List<Casier> trierCasierParBoisson(List<Casier> casiers) {
    List<Casier> casiersParBoisson = List.from(casiers);
    // casiers.sort(
    //   (a, b) => a.boisson.nom!.compareTo(b.boisson.nom!),
    // );

    return casiersParBoisson;
  }

  static List<Casier> getRecentsCasiers(List<Casier> casiers) {
    List<Casier> casiersRecents = List.from(casiers);
    // casiers.sort(
    //   (a, b) => a.boisson.nom!.compareTo(b.boisson.nom!),
    // );

    return casiersRecents;
  }
}
