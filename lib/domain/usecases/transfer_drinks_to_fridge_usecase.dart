import 'package:projet7/core/error/failures.dart';
import 'package:projet7/core/utils/id_generator.dart';
import 'package:projet7/domain/repositories/i_commande_repository.dart';
import 'package:projet7/domain/repositories/i_refrigerateur_repository.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/domain/entities/casier.dart';

/// Use case pour transférer des boissons d'un casier vers un réfrigérateur.
///
/// Copie les boissons du casier vers le frigo avec [estFroid] = true.
/// Génère de nouveaux IDs pour les boissons transférées.
///
/// Lance [NotFoundFailure] si le casier ou le frigo n'existe pas.
/// Lance [ValidationFailure] si le nombre demandé est invalide.
class TransferDrinksToFridgeUseCase {
  final ICommandeRepository commandeRepository;
  final IRefrigerateurRepository refrigerateurRepository;
  final IdGenerator idGenerator;

  TransferDrinksToFridgeUseCase({
    required this.commandeRepository,
    required this.refrigerateurRepository,
    required this.idGenerator,
  });

  /// Transfère [nombre] boissons du casier [casierId] vers le frigo [refrigerateurId]
  Future<void> execute({
    required int casierId,
    required int refrigerateurId,
    required int nombre,
  }) async {
    // 1. Trouver le casier dans les commandes
    Casier? casier;
    for (final commande in commandeRepository.getAll()) {
      try {
        casier = commande.lignesCommande
            .map((ligne) => ligne.casier)
            .firstWhere((c) => c.id == casierId);
        break;
      } catch (e) {
        continue;
      }
    }

    if (casier == null) {
      throw NotFoundFailure('Casier #$casierId non trouvé dans les commandes');
    }

    // 2. Trouver le réfrigérateur
    final refrigerateur = refrigerateurRepository.getById(refrigerateurId);
    if (refrigerateur == null) {
      throw NotFoundFailure('Réfrigérateur #$refrigerateurId non trouvé');
    }

    // 3. Valider le nombre de boissons
    if (casier.boissons.length < nombre || nombre <= 0) {
      throw ValidationFailure(
        'Nombre invalide : demandé $nombre, disponible ${casier.boissons.length}',
      );
    }

    // 4. Préparer la liste des boissons du frigo
    refrigerateur.boissons ??= [];

    // 5. Transférer les boissons (créer de nouvelles instances avec estFroid = true)
    final boissonsToTransfer = <Boisson>[];
    for (final boisson in casier.boissons.sublist(0, nombre)) {
      final newId = await idGenerator.generateUniqueId("Boisson");
      boissonsToTransfer.add(Boisson(
        id: newId,
        nom: boisson.nom,
        prix: List.from(boisson.prix),
        estFroid: true,
        modele: boisson.modele,
        description: boisson.description,
        dateExpiration: boisson.dateExpiration,
      ));
    }

    // 6. Ajouter les boissons au frigo
    refrigerateur.boissons!.addAll(boissonsToTransfer);

    // 7. Sauvegarder le réfrigérateur mis à jour
    await refrigerateurRepository.update(refrigerateur);
  }
}
