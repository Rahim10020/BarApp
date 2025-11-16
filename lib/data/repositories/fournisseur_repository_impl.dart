import 'package:projet7/data/datasources/hive_local_datasource.dart';
import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_fournisseur_repository.dart';
import 'package:projet7/models/fournisseur.dart';

class FournisseurRepositoryImpl extends BaseRepositoryImpl<Fournisseur>
    implements IFournisseurRepository {
  FournisseurRepositoryImpl(HiveLocalDatasource<Fournisseur> datasource)
      : super(datasource);

  @override
  List<Fournisseur> searchByName(String query) {
    final lowerQuery = query.toLowerCase();
    return getAll()
        .where((f) => (f.nom ?? '').toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  List<Fournisseur> searchByContact(String query) {
    final lowerQuery = query.toLowerCase();
    return getAll()
        .where((f) => (f.contact ?? '').toLowerCase().contains(lowerQuery))
        .toList();
  }
}
