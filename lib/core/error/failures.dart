/// Classe de base pour toutes les erreurs de l'application
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Erreur de base de données
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Erreur d'entité non trouvée
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Erreur de validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Erreur de logique métier
class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure(super.message);
}

/// Erreur de génération de fichier
class FileGenerationFailure extends Failure {
  const FileGenerationFailure(super.message);
}
