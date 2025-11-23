import 'package:hive/hive.dart';
import 'package:projet7/core/error/failures.dart';

/// Source de données locale générique utilisant Hive pour la persistance.
///
/// Cette classe fournit une interface CRUD générique pour stocker et
/// récupérer des entités dans une box Hive.
///
/// [T] représente le type de l'entité. L'entité doit avoir un champ `id`
/// accessible via la fonction [getId] fournie au constructeur.
///
/// Toutes les opérations incluent une gestion d'erreurs appropriée
/// avec des exceptions typées ([DatabaseFailure], [NotFoundFailure]).
///
/// Exemple d'utilisation :
/// ```dart
/// final datasource = HiveLocalDatasource<Boisson>(
///   box: boissonBox,
///   getId: (b) => b.id,
/// );
/// final boissons = datasource.getAll();
/// ```
class HiveLocalDatasource<T> {
  final Box<T> box;
  final int Function(T) getId;

  HiveLocalDatasource({
    required this.box,
    required this.getId,
  });

  /// Récupère toutes les entités
  List<T> getAll() {
    try {
      return box.values.toList();
    } catch (e) {
      throw DatabaseFailure('Erreur lors de la récupération des données: $e');
    }
  }

  /// Récupère une entité par son ID
  T? getById(int id) {
    try {
      for (var i = 0; i < box.length; i++) {
        final entity = box.getAt(i);
        if (entity != null && getId(entity) == id) {
          return entity;
        }
      }
      return null;
    } catch (e) {
      throw DatabaseFailure('Erreur lors de la recherche par ID: $e');
    }
  }

  /// Ajoute une entité
  Future<void> add(T entity) async {
    try {
      await box.add(entity);
    } catch (e) {
      throw DatabaseFailure('Erreur lors de l\'ajout: $e');
    }
  }

  /// Met à jour une entité (trouve par ID et remplace)
  Future<void> update(T entity) async {
    try {
      final id = getId(entity);
      int? index;

      // Trouver l'index de l'entité avec cet ID
      for (var i = 0; i < box.length; i++) {
        final existing = box.getAt(i);
        if (existing != null && getId(existing) == id) {
          index = i;
          break;
        }
      }

      if (index == null) {
        throw NotFoundFailure('Entité avec ID $id non trouvée');
      }

      await box.putAt(index, entity);
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw DatabaseFailure('Erreur lors de la mise à jour: $e');
    }
  }

  /// Supprime une entité (trouve par ID et supprime)
  Future<void> delete(T entity) async {
    try {
      final id = getId(entity);
      await deleteById(id);
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw DatabaseFailure('Erreur lors de la suppression: $e');
    }
  }

  /// Supprime une entité par son ID
  Future<void> deleteById(int id) async {
    try {
      int? index;

      // Trouver l'index de l'entité avec cet ID
      for (var i = 0; i < box.length; i++) {
        final existing = box.getAt(i);
        if (existing != null && getId(existing) == id) {
          index = i;
          break;
        }
      }

      if (index == null) {
        throw NotFoundFailure('Entité avec ID $id non trouvée');
      }

      await box.deleteAt(index);
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw DatabaseFailure('Erreur lors de la suppression par ID: $e');
    }
  }

  /// Compte le nombre total d'entités
  int count() {
    return box.length;
  }

  /// Vérifie si une entité existe
  bool exists(int id) {
    return getById(id) != null;
  }

  /// Efface toutes les entités (à utiliser avec précaution !)
  Future<void> clear() async {
    try {
      await box.clear();
    } catch (e) {
      throw DatabaseFailure('Erreur lors du nettoyage: $e');
    }
  }
}
