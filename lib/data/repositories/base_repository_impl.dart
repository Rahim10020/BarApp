import 'package:projet7/data/datasources/hive_local_datasource.dart';
import 'package:projet7/domain/repositories/i_base_repository.dart';

/// Implémentation de base générique pour tous les repositories.
///
/// Cette classe fournit une implémentation par défaut de [IBaseRepository]
/// en déléguant toutes les opérations au [HiveLocalDatasource].
///
/// Les repositories spécifiques étendent cette classe et ajoutent
/// des méthodes additionnelles selon leurs besoins.
///
/// [T] représente le type de l'entité gérée par le repository.
class BaseRepositoryImpl<T> implements IBaseRepository<T> {
  final HiveLocalDatasource<T> datasource;

  BaseRepositoryImpl(this.datasource);

  @override
  List<T> getAll() => datasource.getAll();

  @override
  T? getById(int id) => datasource.getById(id);

  @override
  Future<void> add(T entity) => datasource.add(entity);

  @override
  Future<void> update(T entity) => datasource.update(entity);

  @override
  Future<void> delete(T entity) => datasource.delete(entity);

  @override
  Future<void> deleteById(int id) => datasource.deleteById(id);

  @override
  int count() => datasource.count();

  @override
  bool exists(int id) => datasource.exists(id);
}
