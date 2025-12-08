import 'package:projet7/domain/entities/fournisseur.dart';
import 'i_base_repository.dart';

/// Repository pour la gestion des fournisseurs de boissons.
///
/// Cette interface étend [IBaseRepository] avec des fonctionnalités
/// de recherche par nom et par contact.
///
/// Utilisée pour gérer le carnet d'adresses des fournisseurs.
abstract class IFournisseurRepository extends IBaseRepository<Fournisseur> {
  /// Recherche des fournisseurs dont le nom contient la requête.
  ///
  /// [query] : texte à rechercher dans le nom.
  /// La recherche est insensible à la casse.
  List<Fournisseur> searchByName(String query);

  /// Recherche des fournisseurs par leurs coordonnées de contact.
  ///
  /// [query] : texte à rechercher dans l'adresse/contact.
  /// Utile pour trouver un fournisseur par téléphone ou email.
  List<Fournisseur> searchByContact(String query);
}
