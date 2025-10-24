import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/permissions_screen.dart';
import 'services/lock_screen_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setze bevorzugte Orientierung auf Portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AppLockerApp());
}

class AppLockerApp extends StatefulWidget {
  const AppLockerApp({super.key});

  @override
  State<AppLockerApp> createState() => _AppLockerAppState();
}

class _AppLockerAppState extends State<AppLockerApp> {
  final _lockScreenService = LockScreenService();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Initialisiere Lock Screen Service nach dem ersten Frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_navigatorKey.currentContext != null) {
        _lockScreenService.initialize(_navigatorKey.currentContext!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'AppLocker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const PermissionsScreen(),
    );
  }
}
