import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';

/// Classe représentant une boisson importée depuis JSON
class BoissonImport {
  final String nom;
  final List<double> prix;
  final String? modele;
  final String? description;
  final bool estFroid;

  BoissonImport({
    required this.nom,
    required this.prix,
    this.modele,
    this.description,
    required this.estFroid,
  });

  factory BoissonImport.fromJson(Map<String, dynamic> json) {
    return BoissonImport(
      nom: json['nom'] as String,
      prix: (json['prix'] as List).map((e) => (e as num).toDouble()).toList(),
      modele: json['modele'] as String?,
      description: json['description'] as String?,
      estFroid: json['estFroid'] as bool? ?? false,
    );
  }

  /// Convertit en modèle Boisson
  Boisson toBoisson(int id) {
    Modele? modeleEnum;
    if (modele != null) {
      modeleEnum = modele!.toLowerCase() == 'petit' 
          ? Modele.petit 
          : modele!.toLowerCase() == 'grand'
              ? Modele.grand
              : null;
    }

    return Boisson(
      id: id,
      nom: nom,
      prix: prix,
      estFroid: estFroid,
      modele: modeleEnum,
      description: description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prix': prix,
      'modele': modele,
      'description': description,
      'estFroid': estFroid,
    };
  }
}

/// Service de gestion de l'import des boissons depuis JSON
class BoissonImportService {
  /// Charge les boissons par défaut depuis le fichier assets
  Future<List<BoissonImport>> loadDefaultBoissons() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/boissons_default.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> boissonsJson = jsonData['boissons'] as List;
      return boissonsJson.map((json) => BoissonImport.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors du chargement des boissons par défaut: $e');
      return [];
    }
  }

  /// Parse un fichier JSON de boissons
  Future<List<BoissonImport>> parseJsonString(String jsonString) async {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      if (!jsonData.containsKey('boissons')) {
        throw Exception('Format JSON invalide: clé "boissons" manquante');
      }
      
      final List<dynamic> boissonsJson = jsonData['boissons'] as List;
      return boissonsJson.map((json) => BoissonImport.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse du JSON: $e');
    }
  }

  /// Exporte les boissons actuelles vers JSON
  String exportToJson(List<Boisson> boissons) {
    final Map<String, dynamic> data = {
      'boissons': boissons.map((b) {
        return {
          'nom': b.nom,
          'prix': b.prix,
          'modele': b.modele == Modele.petit ? 'petit' : 'grand',
          'description': b.description,
          'estFroid': b.estFroid,
        };
      }).toList(),
    };
    
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Valide le format d'un JSON de boissons
  bool validateJsonFormat(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      if (!jsonData.containsKey('boissons')) {
        return false;
      }
      
      final List<dynamic> boissonsJson = jsonData['boissons'] as List;
      
      for (var boissonJson in boissonsJson) {
        if (boissonJson is! Map<String, dynamic>) {
          return false;
        }
        
        if (!boissonJson.containsKey('nom') || 
            !boissonJson.containsKey('prix')) {
          return false;
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
}

