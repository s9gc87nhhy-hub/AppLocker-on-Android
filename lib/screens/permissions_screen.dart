import 'package:flutter/material.dart';
import '../services/platform_service.dart';
import 'home_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final PlatformService _platformService = PlatformService();

  bool _usageStatsGranted = false;
  bool _systemAlertGranted = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isChecking = true;
    });

    final usageStats = await _platformService.checkUsageStatsPermission();
    final systemAlert = await _platformService.checkSystemAlertWindowPermission();

    setState(() {
      _usageStatsGranted = usageStats;
      _systemAlertGranted = systemAlert;
      _isChecking = false;
    });

    // Wenn alle Berechtigungen erteilt wurden, zur Home-Screen navigieren
    if (usageStats && systemAlert) {
      _navigateToHome();
    }
  }

  Future<void> _requestUsageStats() async {
    await _platformService.requestUsageStatsPermission();
    // Warte kurz, dann prüfe erneut
    await Future.delayed(const Duration(seconds: 1));
    await _checkPermissions();
  }

  Future<void> _requestSystemAlert() async {
    await _platformService.requestSystemAlertWindowPermission();
    // Warte kurz, dann prüfe erneut
    await Future.delayed(const Duration(seconds: 1));
    await _checkPermissions();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final allGranted = _usageStatsGranted && _systemAlertGranted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berechtigungen erforderlich'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Icon(
                Icons.security,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Berechtigungen einrichten',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'AppLocker benötigt diese Berechtigungen, um Apps effektiv zu sperren',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Usage Stats Berechtigung
              _buildPermissionCard(
                icon: Icons.bar_chart,
                title: 'App-Nutzungszugriff',
                description:
                    'Ermöglicht das Erkennen, wenn eine gesperrte App gestartet wird',
                isGranted: _usageStatsGranted,
                onRequest: _requestUsageStats,
              ),

              const SizedBox(height: 16),

              // System Alert Window Berechtigung
              _buildPermissionCard(
                icon: Icons.layers,
                title: 'Über anderen Apps anzeigen',
                description:
                    'Ermöglicht das Anzeigen des Lock-Screens über anderen Apps',
                isGranted: _systemAlertGranted,
                onRequest: _requestSystemAlert,
              ),

              const Spacer(),

              // Weiter-Button
              if (allGranted)
                ElevatedButton.icon(
                  onPressed: _navigateToHome,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Weiter'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: _checkPermissions,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Status aktualisieren'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onRequest,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isGranted
              ? Colors.green.withOpacity(0.3)
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isGranted
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  isGranted ? Icons.check_circle : Icons.cancel,
                  color: isGranted ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            if (!isGranted) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRequest,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Berechtigung erteilen'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
