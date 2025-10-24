import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart' as installed;
import 'package:permission_handler/permission_handler.dart';
import '../models/app_info.dart';
import '../services/app_lock_service.dart';
import '../services/auth_service.dart';
import 'lock_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppLockService _appLockService = AppLockService();
  final AuthService _authService = AuthService();

  List<AppInfo> _allApps = [];
  List<AppInfo> _filteredApps = [];
  bool _isLoading = true;
  bool _isBiometricAvailable = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkBiometric();
    await _loadApps();
  }

  Future<void> _checkBiometric() async {
    final isAvailable = await _authService.isBiometricAvailable();
    setState(() {
      _isBiometricAvailable = isAvailable;
    });

    if (!isAvailable) {
      if (mounted) {
        _showBiometricNotAvailableDialog();
      }
    }
  }

  Future<void> _loadApps() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lade alle installierten Apps
      final apps = await InstalledApps.getInstalledApps(
        true, // includeAppIcons
        false, // includeSystemApps
      );

      // Lade gesperrte Apps
      final lockedPackages = await _appLockService.getLockedApps();

      // Konvertiere zu AppInfo-Objekten und filtere Apps mit Launch Intent
      final appInfoList = apps.where((app) {
        // Nur Apps mit Launch Intent einbeziehen
        return app.packageName.isNotEmpty;
      }).map((app) {
        return AppInfo(
          appName: app.name,
          packageName: app.packageName,
          icon: app.icon,
          isLocked: lockedPackages.contains(app.packageName),
        );
      }).toList();

      // Sortiere alphabetisch
      appInfoList.sort((a, b) => a.appName.compareTo(b.appName));

      setState(() {
        _allApps = appInfoList;
        _filteredApps = appInfoList;
        _isLoading = false;
      });
    } catch (e) {
      print('Fehler beim Laden der Apps: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showErrorDialog('Fehler beim Laden der Apps: $e');
      }
    }
  }

  void _filterApps(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredApps = _allApps;
      } else {
        _filteredApps = _allApps
            .where((app) =>
                app.appName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _toggleAppLock(AppInfo app) async {
    if (!_isBiometricAvailable) {
      _showBiometricNotAvailableDialog();
      return;
    }

    final newLockState = !app.isLocked;

    if (newLockState) {
      // App sperren
      final success = await _appLockService.lockApp(app.packageName);
      if (success) {
        setState(() {
          app.isLocked = true;
        });
        _showSnackBar('${app.appName} wurde gesperrt');
      }
    } else {
      // App entsperren - Authentifizierung erforderlich
      final authenticated = await _authService.authenticate(
        localizedReason: '${app.appName} entsperren',
      );

      if (authenticated) {
        final success = await _appLockService.unlockApp(app.packageName);
        if (success) {
          setState(() {
            app.isLocked = false;
          });
          _showSnackBar('${app.appName} wurde entsperrt');
        }
      }
    }
  }

  void _showBiometricNotAvailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Biometrie nicht verfügbar'),
        content: const Text(
          'Ihr Gerät unterstützt keine biometrische Authentifizierung oder '
          'es wurde kein Fingerabdruck eingerichtet. Bitte aktivieren Sie '
          'die biometrische Authentifizierung in den Geräteeinstellungen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fehler'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _testLockScreen() async {
    if (!_isBiometricAvailable) {
      _showBiometricNotAvailableDialog();
      return;
    }

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const LockScreen(
          appName: 'Test App',
          packageName: 'com.test.app',
        ),
      ),
    );

    if (result == true && mounted) {
      _showSnackBar('Authentifizierung erfolgreich!');
    }
  }

  int get _lockedAppsCount =>
      _allApps.where((app) => app.isLocked).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppLocker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.fingerprint),
            onPressed: _testLockScreen,
            tooltip: 'Lock-Screen testen',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadApps,
            tooltip: 'Apps neu laden',
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistik-Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.apps,
                  label: 'Apps gesamt',
                  value: '${_allApps.length}',
                ),
                _buildStatItem(
                  icon: Icons.lock,
                  label: 'Gesperrt',
                  value: '$_lockedAppsCount',
                  color: Theme.of(context).colorScheme.primary,
                ),
                _buildStatItem(
                  icon: Icons.fingerprint,
                  label: 'Biometrie',
                  value: _isBiometricAvailable ? '✓' : '✗',
                  color: _isBiometricAvailable ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),

          // Suchfeld
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterApps,
              decoration: InputDecoration(
                hintText: 'Apps durchsuchen...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _filterApps('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // App-Liste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredApps.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Keine Apps gefunden',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredApps.length,
                        itemBuilder: (context, index) {
                          final app = _filteredApps[index];
                          return _buildAppTile(app);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAppTile(AppInfo app) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: app.icon != null
            ? CircleAvatar(
                backgroundImage: MemoryImage(app.icon!),
                backgroundColor: Colors.transparent,
              )
            : CircleAvatar(
                child: Text(app.appName[0].toUpperCase()),
              ),
        title: Text(
          app.appName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          app.packageName,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Switch(
          value: app.isLocked,
          onChanged: (_) => _toggleAppLock(app),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => _toggleAppLock(app),
      ),
    );
  }
}
