/// Interface de base définissant les opérations CRUD pour tous les repositories.
///
/// Cette interface générique sert de contrat pour toutes les classes repository
/// de l'application, garantissant une API cohérente pour la manipulation des données.
///
/// [T] représente le type de l'entité gérée par le repository.
///
/// Les opérations de lecture sont synchrones car Hive les supporte en mémoire.
/// Les opérations d'écriture sont asynchrones pour permettre la persistance.
abstract class IBaseRepository<T> {
  /// Récupère toutes les entités stockées dans le repository.
  ///
  /// Retourne une liste de toutes les entités de type [T].
  /// La liste peut être vide si aucune entité n'existe.
  List<T> getAll();

  /// Récupère une entité spécifique par son identifiant.
  ///
  /// [id] : identifiant unique de l'entité recherchée.
  /// Retourne l'entité si elle existe, `null` sinon.
  T? getById(int id);

  /// Ajoute une nouvelle entité au repository.
  ///
  /// [entity] : l'entité à persister.
  /// Cette opération est asynchrone car elle implique une écriture en base.
  Future<void> add(T entity);

  /// Met à jour une entité existante dans le repository.
  ///
  /// [entity] : l'entité avec les nouvelles valeurs à persister.
  /// L'entité doit déjà exister dans le repository.
  Future<void> update(T entity);

  /// Supprime une entité du repository.
  ///
  /// [entity] : l'entité à supprimer.
  Future<void> delete(T entity);

  /// Supprime une entité par son identifiant.
  ///
  /// [id] : identifiant unique de l'entité à supprimer.
  /// Utile quand on ne dispose que de l'ID sans l'objet complet.
  Future<void> deleteById(int id);

  /// Compte le nombre total d'entités dans le repository.
  ///
  /// Retourne le nombre d'entités stockées.
  int count();

  /// Vérifie si une entité existe dans le repository.
  ///
  /// [id] : identifiant unique de l'entité à vérifier.
  /// Retourne `true` si l'entité existe, `false` sinon.
  bool exists(int id);
}
