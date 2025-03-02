import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';

class BoissonUtil {
  static List<Boisson> getPetitModele(List<Boisson> boissons) {
    return boissons.where((b) => b.modele == Modele.petit).toList();
  }

  static List<Boisson> getGrandModele(List<Boisson> boissons) {
    return boissons.where((b) => b.modele == Modele.grand).toList();
  }
}
