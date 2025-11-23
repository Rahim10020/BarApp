/// Classe de base abstraite pour toutes les erreurs de l'application.
///
/// Utilise le pattern Failure pour une gestion d'erreurs typée et prévisible.
/// Chaque type d'erreur étend cette classe avec un message descriptif.
///
/// Exemple d'utilisation :
/// ```dart
/// throw DatabaseFailure('Erreur de connexion à Hive');
/// ```
abstract class Failure {
  /// Message descriptif de l'erreur.
  final String message;

  /// Crée une nouvelle instance de [Failure].
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Erreur liée aux opérations de base de données (Hive).
///
/// Utilisée pour les erreurs de lecture, écriture ou connexion à la base.
class DatabaseFailure extends Failure {
  /// Crée une erreur de base de données avec le [message] d'erreur.
  const DatabaseFailure(super.message);
}

/// Erreur indiquant qu'une entité recherchée n'existe pas.
///
/// Utilisée quand une opération tente d'accéder à une entité par ID inexistant.
class NotFoundFailure extends Failure {
  /// Crée une erreur "non trouvé" avec le [message] d'erreur.
  const NotFoundFailure(super.message);
}

/// Erreur de validation des données d'entrée.
///
/// Utilisée quand les paramètres fournis ne respectent pas les contraintes.
class ValidationFailure extends Failure {
  /// Crée une erreur de validation avec le [message] d'erreur.
  const ValidationFailure(super.message);
}

/// Erreur de logique métier.
///
/// Utilisée quand une opération viole une règle métier de l'application.
class BusinessLogicFailure extends Failure {
  /// Crée une erreur de logique métier avec le [message] d'erreur.
  const BusinessLogicFailure(super.message);
}

/// Erreur lors de la génération de fichiers (PDF, etc.).
///
/// Utilisée quand la création ou l'écriture d'un fichier échoue.
class FileGenerationFailure extends Failure {
  /// Crée une erreur de génération de fichier avec le [message] d'erreur.
  const FileGenerationFailure(super.message);
}
