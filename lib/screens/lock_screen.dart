import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

class LockScreen extends StatefulWidget {
  final String appName;
  final String packageName;

  const LockScreen({
    super.key,
    required this.appName,
    required this.packageName,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isAuthenticating = false;
  String _statusMessage = 'Berühren Sie den Fingerabdruck-Sensor';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _authenticate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _authenticate() async {
    if (!mounted) return;

    setState(() {
      _isAuthenticating = true;
      _statusMessage = 'Authentifizierung läuft...';
    });

    // Kurze Verzögerung für bessere UX
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result = await _authService.authenticate(
        localizedReason: 'Authentifizieren Sie sich, um ${widget.appName} zu öffnen',
      );

      if (!mounted) return;

      if (result) {
        setState(() {
          _statusMessage = 'Erfolgreich authentifiziert!';
        });

        // Kurze Verzögerung, um Erfolg anzuzeigen
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        // Authentifizierung fehlgeschlagen - automatisch erneut versuchen
        setState(() {
          _statusMessage = 'Authentifizierung fehlgeschlagen. Erneuter Versuch...';
          _isAuthenticating = false;
        });

        // Nach Fehler automatisch erneut versuchen
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _authenticate(); // Automatisch neu starten
        }
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Fehler bei der Authentifizierung. Erneuter Versuch...';
        _isAuthenticating = false;
      });

      // Auch bei Fehlern automatisch erneut versuchen
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _authenticate(); // Automatisch neu starten
      }
    }
  }

  void _cancel() {
    _authService.stopAuthentication();
    // Schließe die gesperrte App, indem wir die Authentifizierung als fehlgeschlagen markieren
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    Navigator.pop(context, false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Verhindert Zurück-Navigation komplett
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _cancel();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // App-Name
                Text(
                  widget.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'ist gesperrt',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // Fingerabdruck-Icon mit Animation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.fingerprint,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Status-Nachricht
                Text(
                  _statusMessage,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Zusätzliche Anweisungen
                Text(
                  'Verwenden Sie Ihren registrierten Fingerabdruck',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Abbrechen-Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _cancel,
                    icon: const Icon(Icons.close),
                    label: const Text('Abbrechen'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Erneut versuchen-Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isAuthenticating ? null : _authenticate,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Erneut versuchen'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
