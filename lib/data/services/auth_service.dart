import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

/// Service de gestion de l'authentification biométrique et par code PIN
///
/// Ce service gère deux méthodes d'authentification :
/// 1. Authentification biométrique (empreinte digitale, Face ID, etc.)
/// 2. Authentification par code PIN (fallback si biométrie non disponible)
class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _pinKey = 'user_pin';
  static const String _authEnabledKey = 'auth_enabled';
  static const String _useBiometricKey = 'use_biometric';

  /// Vérifie si le device supporte l'authentification biométrique
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || 
                                   await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  /// Récupère la liste des types de biométrie disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return <BiometricType>[];
    }
  }

  /// Vérifie si l'authentification est activée
  Future<bool> isAuthEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authEnabledKey) ?? false;
  }

  /// Active l'authentification avec un code PIN
  Future<void> enableAuthWithPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
    await prefs.setBool(_authEnabledKey, true);
    await prefs.setBool(_useBiometricKey, false);
  }

  /// Active l'authentification biométrique (avec code PIN en fallback)
  Future<void> enableAuthWithBiometric(String pinFallback) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pinFallback);
    await prefs.setBool(_authEnabledKey, true);
    await prefs.setBool(_useBiometricKey, true);
  }

  /// Désactive l'authentification
  Future<void> disableAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
    await prefs.setBool(_authEnabledKey, false);
    await prefs.remove(_useBiometricKey);
  }

  /// Vérifie si l'utilisateur préfère utiliser la biométrie
  Future<bool> shouldUseBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useBiometricKey) ?? false;
  }

  /// Authentification biométrique
  Future<bool> authenticateWithBiometric() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Veuillez vous authentifier pour accéder à l\'application',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      print('Erreur d\'authentification biométrique: ${e.message}');
      return false;
    }
  }

  /// Authentification par code PIN
  Future<bool> authenticateWithPin(String enteredPin) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedPin = prefs.getString(_pinKey);
    
    if (storedPin == null) {
      return false;
    }
    
    return enteredPin == storedPin;
  }

  /// Vérifie le code PIN stocké
  Future<String?> getStoredPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  /// Change le code PIN
  Future<bool> changePin(String oldPin, String newPin) async {
    if (await authenticateWithPin(oldPin)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinKey, newPin);
      return true;
    }
    return false;
  }

  /// Authentification complète (essaie biométrie, puis PIN en fallback)
  Future<bool> authenticate() async {
    final isEnabled = await isAuthEnabled();
    if (!isEnabled) {
      return true; // Pas d'authentification requise
    }

    final useBiometric = await shouldUseBiometric();
    if (useBiometric) {
      final biometricAvailable = await isBiometricAvailable();
      if (biometricAvailable) {
        // Tenter l'authentification biométrique
        return await authenticateWithBiometric();
      }
    }

    // Fallback sur PIN sera géré par l'UI
    return false;
  }
}

