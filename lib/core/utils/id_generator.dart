import 'package:hive/hive.dart';
import 'package:projet7/models/id_counter.dart';

/// Générateur d'identifiants uniques séquentiels pour chaque type d'entité.
///
/// Utilise une box Hive pour persister les compteurs et garantir
/// l'unicité des IDs même après redémarrage de l'application.
///
/// Chaque type d'entité (Boisson, Casier, Vente, etc.) a son propre compteur
/// indépendant, permettant une numérotation séparée.
///
/// Exemple d'utilisation :
/// ```dart
/// final id = await idGenerator.generateUniqueId('Boisson');
/// final boisson = Boisson(id: id, ...);
/// ```
class IdGenerator {
  final Box<IdCounter> _idCounterBox;

  IdGenerator(this._idCounterBox);

  /// Génère un ID unique pour un type d'entité donné
  Future<int> generateUniqueId(String entityType) async {
    // Trouver ou créer le compteur pour ce type d'entité
    IdCounter? counter;
    int? counterIndex;

    // Chercher le compteur existant
    for (var i = 0; i < _idCounterBox.length; i++) {
      final c = _idCounterBox.getAt(i);
      if (c != null && c.entityType == entityType) {
        counter = c;
        counterIndex = i;
        break;
      }
    }

    // Si pas trouvé, créer un nouveau compteur
    counter ??= IdCounter(entityType: entityType, lastId: 0);

    // Incrémenter
    counter.lastId += 1;

    // Sauvegarder
    if (counterIndex != null) {
      await _idCounterBox.putAt(counterIndex, counter);
    } else {
      await _idCounterBox.add(counter);
    }

    return counter.lastId;
  }

  /// Réinitialise tous les compteurs (à utiliser avec précaution !)
  Future<void> resetAllCounters() async {
    await _idCounterBox.clear();
  }

  /// Récupère le dernier ID généré pour un type d'entité
  int? getLastId(String entityType) {
    for (var i = 0; i < _idCounterBox.length; i++) {
      final c = _idCounterBox.getAt(i);
      if (c != null && c.entityType == entityType) {
        return c.lastId;
      }
    }
    return null;
  }
}
