import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel('com.applocker.app_locker/permissions');

  /// Prüft, ob die Usage Stats Berechtigung erteilt wurde
  Future<bool> checkUsageStatsPermission() async {
    try {
      final bool result = await platform.invokeMethod('checkUsageStatsPermission');
      return result;
    } on PlatformException catch (e) {
      print('Fehler beim Prüfen der Usage Stats Berechtigung: ${e.message}');
      return false;
    }
  }

  /// Fordert die Usage Stats Berechtigung an
  Future<void> requestUsageStatsPermission() async {
    try {
      await platform.invokeMethod('requestUsageStatsPermission');
    } on PlatformException catch (e) {
      print('Fehler beim Anfordern der Usage Stats Berechtigung: ${e.message}');
    }
  }

  /// Prüft, ob die System Alert Window Berechtigung erteilt wurde
  Future<bool> checkSystemAlertWindowPermission() async {
    try {
      final bool result = await platform.invokeMethod('checkSystemAlertWindowPermission');
      return result;
    } on PlatformException catch (e) {
      print('Fehler beim Prüfen der System Alert Window Berechtigung: ${e.message}');
      return false;
    }
  }

  /// Fordert die System Alert Window Berechtigung an
  Future<void> requestSystemAlertWindowPermission() async {
    try {
      await platform.invokeMethod('requestSystemAlertWindowPermission');
    } on PlatformException catch (e) {
      print('Fehler beim Anfordern der System Alert Window Berechtigung: ${e.message}');
    }
  }

  /// Startet den App-Überwachungsservice
  Future<bool> startMonitoringService() async {
    try {
      final bool result = await platform.invokeMethod('startMonitoringService');
      return result;
    } on PlatformException catch (e) {
      print('Fehler beim Starten des Monitoring Service: ${e.message}');
      return false;
    }
  }

  /// Stoppt den App-Überwachungsservice
  Future<bool> stopMonitoringService() async {
    try {
      final bool result = await platform.invokeMethod('stopMonitoringService');
      return result;
    } on PlatformException catch (e) {
      print('Fehler beim Stoppen des Monitoring Service: ${e.message}');
      return false;
    }
  }
}
