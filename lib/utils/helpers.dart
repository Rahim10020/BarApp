import 'package:projet7/utils/modele.dart';

Modele? getModele(String modele) {
  switch (modele) {
    case "Petit":
      return Modele.petit;
    case "Grand":
      return Modele.grand;
  }
  return null;
}

String? getModeleString(Modele? modele) {
  switch (modele) {
    case Modele.petit:
      return "Petit";
    case Modele.grand:
      return "Grand";
    case null:
      return null;
  }
}
