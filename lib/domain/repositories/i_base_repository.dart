/// Interface de base pour tous les repositories
/// T = Type de l'entité
abstract class IBaseRepository<T> {
  /// Récupère toutes les entités
  List<T> getAll();

  /// Récupère une entité par son ID
  T? getById(int id);

  /// Ajoute une nouvelle entité
  Future<void> add(T entity);

  /// Met à jour une entité existante
  Future<void> update(T entity);

  /// Supprime une entité
  Future<void> delete(T entity);

  /// Supprime une entité par son ID
  Future<void> deleteById(int id);

  /// Compte le nombre total d'entités
  int count();

  /// Vérifie si une entité existe
  bool exists(int id);
}
