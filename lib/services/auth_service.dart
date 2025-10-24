import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Prüft, ob das Gerät biometrische Authentifizierung unterstützt
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Prüft, ob biometrische Authentifizierung verfügbar ist
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await canCheckBiometrics();
      if (!canCheck) return false;

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Führt die biometrische Authentifizierung durch
  Future<bool> authenticate({
    String localizedReason = 'Bitte authentifizieren Sie sich, um fortzufahren',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Authentifizierung erforderlich',
            cancelButton: 'Abbrechen',
            biometricHint: 'Fingerabdruck scannen',
            biometricNotRecognized: 'Fingerabdruck nicht erkannt',
            biometricSuccess: 'Erfolgreich authentifiziert',
            deviceCredentialsRequiredTitle: 'Geräte-Anmeldeinformationen erforderlich',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      // Fehlerbehandlung
      print('Authentifizierungsfehler: ${e.message}');
      return false;
    } catch (e) {
      print('Unerwarteter Fehler: $e');
      return false;
    }
  }

  /// Gibt die verfügbaren biometrischen Methoden zurück
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Stoppt die laufende Authentifizierung
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      print('Fehler beim Stoppen der Authentifizierung: $e');
    }
  }
}
