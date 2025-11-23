import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Use case pour la sauvegarde et la restauration des données de l'application.
///
/// Permet d'exporter toutes les données Hive vers des fichiers JSON
/// et de les restaurer ultérieurement pour la récupération de données.
///
/// Les sauvegardes sont stockées dans le dossier Documents de l'application.
class BackupRestoreUseCase {
  final Map<String, Box> boxes;

  BackupRestoreUseCase({required this.boxes});

  /// Sauvegarde toutes les données dans des fichiers JSON
  Future<void> backupData() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backup');

    if (!await backupDir.exists()) {
      await backupDir.create();
    }

    // Sauvegarder chaque box
    for (final entry in boxes.entries) {
      final boxName = entry.key;
      final box = entry.value;
      await _backupBox(box, '${backupDir.path}/$boxName.json');
    }
  }

  /// Restaure toutes les données depuis les fichiers JSON
  Future<void> restoreData() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backup');

    if (!await backupDir.exists()) {
      throw Exception('Aucune sauvegarde trouvée');
    }

    // Restaurer chaque box
    for (final entry in boxes.entries) {
      final boxName = entry.key;
      final box = entry.value;
      await _restoreBox(box, '${backupDir.path}/$boxName.json');
    }
  }

  /// Sauvegarde une box individuelle
  Future<void> _backupBox(Box box, String path) async {
    final data = box.toMap();
    final file = File(path);
    await file.writeAsString(jsonEncode(data));
  }

  /// Restaure une box individuelle
  Future<void> _restoreBox(Box box, String path) async {
    final file = File(path);
    if (await file.exists()) {
      final data = jsonDecode(await file.readAsString());
      await box.clear();
      for (final entry in data.entries) {
        await box.put(entry.key, entry.value);
      }
    }
  }

  /// Vérifie si une sauvegarde existe
  Future<bool> hasBackup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${directory.path}/backup');
      return await backupDir.exists();
    } catch (e) {
      return false;
    }
  }

  /// Récupère la date de la dernière sauvegarde
  Future<DateTime?> getLastBackupDate() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${directory.path}/backup');

      if (!await backupDir.exists()) return null;

      final stat = await backupDir.stat();
      return stat.modified;
    } catch (e) {
      return null;
    }
  }
}
