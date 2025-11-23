import 'package:hive/hive.dart';
import 'package:projet7/core/utils/id_generator.dart';
import 'package:projet7/domain/repositories/i_bar_repository.dart';
import 'package:projet7/models/bar_instance.dart';

/// Implémentation concrète du repository pour la configuration du bar.
///
/// Gère l'instance unique du bar dans l'application.
/// Utilise directement une box Hive car il n'y a qu'un seul bar.
///
/// Le bar est toujours stocké au premier index de la box.
class BarRepositoryImpl implements IBarRepository {
  final Box<BarInstance> box;
  final IdGenerator idGenerator;

  BarRepositoryImpl({
    required this.box,
    required this.idGenerator,
  });

  @override
  BarInstance? getCurrentBar() {
    if (box.isEmpty) return null;
    return box.values.first;
  }

  @override
  Future<void> createBar(String nom, String adresse) async {
    final id = await idGenerator.generateUniqueId("BarInstance");
    final bar = BarInstance(id: id, nom: nom, adresse: adresse);
    await box.add(bar);
  }

  @override
  Future<void> updateBar(BarInstance bar) async {
    if (box.isEmpty) {
      throw Exception('Aucun bar à mettre à jour');
    }
    await box.putAt(0, bar);
  }

  @override
  bool hasBar() {
    return box.isNotEmpty;
  }
}
