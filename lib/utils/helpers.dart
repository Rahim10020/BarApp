import 'package:projet7/models/modele.dart';

class Helpers {
  static Modele getModele(String modele) {
    switch (modele) {
      case "Petit":
        return Modele.petit;
      case "Grand":
        return Modele.grand;
    }
    return Modele.grand;
  }

  static String? getModeleToString(Modele? modele) {
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
