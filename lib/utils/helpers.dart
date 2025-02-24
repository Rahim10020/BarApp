import 'package:intl/intl.dart';
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

  static String formatterEnCFA(double montant) {
    return NumberFormat.currency(
            locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
        .format(montant);
  }

  static String formatterDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()} à ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
  }
}
