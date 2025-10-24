import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_info.dart';

class AppLockService {
  static const String _lockedAppsKey = 'locked_apps';
  static const String _isAppLockEnabledKey = 'is_app_lock_enabled';

  /// Speichert die Liste der gesperrten Apps
  Future<bool> saveLockedApps(List<String> packageNames) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setStringList(_lockedAppsKey, packageNames);
    } catch (e) {
      print('Fehler beim Speichern gesperrter Apps: $e');
      return false;
    }
  }

  /// Lädt die Liste der gesperrten Apps
  Future<List<String>> getLockedApps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_lockedAppsKey) ?? [];
    } catch (e) {
      print('Fehler beim Laden gesperrter Apps: $e');
      return [];
    }
  }

  /// Fügt eine App zur Sperrliste hinzu
  Future<bool> lockApp(String packageName) async {
    try {
      final lockedApps = await getLockedApps();
      if (!lockedApps.contains(packageName)) {
        lockedApps.add(packageName);
        return await saveLockedApps(lockedApps);
      }
      return true;
    } catch (e) {
      print('Fehler beim Sperren der App: $e');
      return false;
    }
  }

  /// Entfernt eine App von der Sperrliste
  Future<bool> unlockApp(String packageName) async {
    try {
      final lockedApps = await getLockedApps();
      lockedApps.remove(packageName);
      return await saveLockedApps(lockedApps);
    } catch (e) {
      print('Fehler beim Entsperren der App: $e');
      return false;
    }
  }

  /// Prüft, ob eine App gesperrt ist
  Future<bool> isAppLocked(String packageName) async {
    try {
      final lockedApps = await getLockedApps();
      return lockedApps.contains(packageName);
    } catch (e) {
      print('Fehler beim Prüfen des App-Status: $e');
      return false;
    }
  }

  /// Aktiviert/Deaktiviert die App-Sperre global
  Future<bool> setAppLockEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_isAppLockEnabledKey, enabled);
    } catch (e) {
      print('Fehler beim Setzen des App-Lock-Status: $e');
      return false;
    }
  }

  /// Prüft, ob die App-Sperre aktiviert ist
  Future<bool> isAppLockEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isAppLockEnabledKey) ?? true;
    } catch (e) {
      print('Fehler beim Abrufen des App-Lock-Status: $e');
      return true;
    }
  }

  /// Löscht alle gesperrten Apps
  Future<bool> clearAllLockedApps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_lockedAppsKey);
    } catch (e) {
      print('Fehler beim Löschen aller gesperrten Apps: $e');
      return false;
    }
  }

  /// Gibt die Anzahl der gesperrten Apps zurück
  Future<int> getLockedAppsCount() async {
    try {
      final lockedApps = await getLockedApps();
      return lockedApps.length;
    } catch (e) {
      print('Fehler beim Abrufen der Anzahl gesperrter Apps: $e');
      return 0;
    }
  }
}
