import 'package:projet7/models/fournisseur.dart';
import 'i_base_repository.dart';

/// Repository pour les fournisseurs
abstract class IFournisseurRepository extends IBaseRepository<Fournisseur> {
  /// Recherche des fournisseurs par nom
  List<Fournisseur> searchByName(String query);

  /// Recherche par contact
  List<Fournisseur> searchByContact(String query);
}
