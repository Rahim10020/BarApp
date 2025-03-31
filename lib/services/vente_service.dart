import 'package:hive_flutter/adapters.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';

class VenteService {
  final String _venteBoxName = 'ventes';
  // final String _boissonBoxName = 'boissons';
  final String _refrigerateurBoxName = 'refrigerateurs';

  Future<void> ajouterVente(List<Boisson> boissonsVendues) async {
    var venteBox = await Hive.openBox<Vente>(_venteBoxName);
    // var boissonBox = await Hive.openBox<Boisson>(_boissonBoxName);
    var refrigerateurBox =
        await Hive.openBox<Refrigerateur>(_refrigerateurBoxName);

    List<LigneVente> lignesVente = boissonsVendues.asMap().entries.map((entry) {
      int index = entry.key;
      Boisson boisson = entry.value;
      return LigneVente(
        id: index,
        montant: boisson.prix.last,
        boisson: boisson,
      );
    }).toList();

    double montantTotal =
        lignesVente.fold(0.0, (sum, ligne) => sum + ligne.montant);

    Vente nouvelleVente = Vente(
      id: venteBox.length,
      montantTotal: montantTotal,
      dateVente: DateTime.now(),
      lignesVente: lignesVente,
    );

    await venteBox.add(nouvelleVente);

    var refrigerateur = refrigerateurBox.get(0);
    if (refrigerateur != null && refrigerateur.boissons != null) {
      for (var boissonVendues in boissonsVendues) {
        refrigerateur.boissons!.removeWhere((b) => b.id == boissonVendues.id);
      }
      await refrigerateurBox.put(0, refrigerateur);
    }
  }

  Future<List<Vente>> getVentes() async {
    var venteBox = await Hive.openBox<Vente>(_venteBoxName);
    return venteBox.values.toList();
  }

  Future<List<Vente>> getVentesTriees(
      {bool parDate = true, bool ascendant = true}) async {
    var ventes = await getVentes();
    ventes.sort((a, b) {
      if (parDate) {
        return ascendant
            ? a.dateVente.compareTo(b.dateVente)
            : b.dateVente.compareTo(a.dateVente);
      } else {
        return ascendant
            ? a.montantTotal.compareTo(b.montantTotal)
            : b.montantTotal.compareTo(a.montantTotal);
      }
    });
    return ventes;
  }

  // Nouvelle fonction de recherche
  Future<List<Vente>> rechercherVentes(String query) async {
    var ventes = await getVentes();
    if (query.isEmpty) return ventes;
    return ventes.where((vente) {
      final queryLower = query.toLowerCase();
      return vente.id.toString().contains(queryLower) ||
          vente.dateVente.toString().toLowerCase().contains(queryLower) ||
          vente.lignesVente.any((ligne) =>
              ligne.boisson.nom?.toLowerCase().contains(queryLower) ?? false);
    }).toList();
  }
}
