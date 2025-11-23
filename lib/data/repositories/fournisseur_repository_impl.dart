import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_fournisseur_repository.dart';
import 'package:projet7/models/fournisseur.dart';

/// Implémentation concrète du repository des fournisseurs.
///
/// Étend [BaseRepositoryImpl] avec les opérations de recherche
/// par nom et par coordonnées de contact.
class FournisseurRepositoryImpl extends BaseRepositoryImpl<Fournisseur>
    implements IFournisseurRepository {
  FournisseurRepositoryImpl(super.datasource);

  @override
  List<Fournisseur> searchByName(String query) {
    final lowerQuery = query.toLowerCase();
    return getAll()
        .where((f) => (f.nom).toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  List<Fournisseur> searchByContact(String query) {
    final lowerQuery = query.toLowerCase();
    return getAll()
        .where((f) => (f.adresse ?? '').toLowerCase().contains(lowerQuery))
        .toList();
  }
}
