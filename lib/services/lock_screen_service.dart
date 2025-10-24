import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import '../models/app_info.dart';
import '../screens/lock_screen.dart';

class LockScreenService {
  static const platform = MethodChannel('com.applocker.app_locker/lock_screen');
  static final LockScreenService _instance = LockScreenService._internal();

  factory LockScreenService() {
    return _instance;
  }

  LockScreenService._internal();

  BuildContext? _context;

  /// Initialisiert den Lock Screen Service mit dem BuildContext
  void initialize(BuildContext context) {
    _context = context;
    _setupMethodChannel();
  }

  /// Setzt den Method Channel auf, um Lock Screen-Aufrufe zu empfangen
  void _setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'showLockScreen') {
        final String? packageName = call.arguments['packageName'];
        if (packageName != null && _context != null) {
          await _showLockScreenForPackage(packageName);
        }
      }
    });
  }

  /// Zeigt den Lock Screen für die angegebene App an
  Future<void> _showLockScreenForPackage(String packageName) async {
    if (_context == null) return;

    try {
      // Hole App-Informationen
      final appInfo = await _getAppInfo(packageName);

      if (appInfo != null && _context != null) {
        // Navigiere zum Lock Screen
        final result = await Navigator.of(_context!).push(
          MaterialPageRoute(
            builder: (context) => LockScreen(
              appName: appInfo.appName,
              packageName: packageName,
            ),
            fullscreenDialog: true,
          ),
        );

        // Wenn Authentifizierung fehlgeschlagen ist, schließe die gesperrte App
        if (result != true) {
          _closeLockedApp(packageName);
        }
      }
    } catch (e) {
      print('Fehler beim Anzeigen des Lock Screens: $e');
    }
  }

  /// Holt Informationen über eine installierte App
  Future<AppInfo?> _getAppInfo(String packageName) async {
    try {
      final apps = await InstalledApps.getInstalledApps(
        true, // includeAppIcons
        false, // includeSystemApps
      );

      // Find the app and convert to local AppInfo model
      final installedApp = apps.cast<dynamic>().firstWhere(
        (app) => app.packageName == packageName,
        orElse: () => null,
      );

      if (installedApp != null) {
        return AppInfo(
          appName: installedApp.name,
          packageName: installedApp.packageName,
          icon: installedApp.icon,
        );
      }

      // Fallback if app not found
      return AppInfo(
        appName: packageName,
        packageName: packageName,
        icon: null,
      );
    } catch (e) {
      print('Fehler beim Abrufen der App-Informationen: $e');
      return null;
    }
  }

  /// Schließt die gesperrte App (bringt Benutzer zurück zum Home Screen)
  void _closeLockedApp(String packageName) {
    // Bringe App in den Hintergrund
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
