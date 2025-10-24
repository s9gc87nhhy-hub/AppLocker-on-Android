# AppLocker for Android

<div align="center">
  <h3>🔒 Sichere deine Apps mit Fingerabdruck-Authentifizierung 🔒</h3>
  <p>Eine moderne Flutter-Anwendung zum Sperren von Android-Apps</p>
</div>

---

## 📱 Über die App

AppLocker ist eine benutzerfreundliche Android-Anwendung, die es ermöglicht, ausgewählte Apps mit biometrischer Authentifizierung (Fingerabdruck) zu sperren. Die App läuft im Hintergrund und überwacht kontinuierlich, welche Apps gestartet werden. Sobald eine gesperrte App geöffnet wird, erscheint ein Lock-Screen, der eine Fingerabdruck-Authentifizierung erfordert.

## ✨ Hauptfunktionen

- 🔐 **Biometrische Authentifizierung**: Sichern Sie Apps mit Fingerabdruck
- 📋 **App-Verwaltung**: Einfache Auswahl der zu sperrenden Apps
- 🔍 **Intelligente Suche**: Finden Sie Apps schnell mit der Suchfunktion
- 🎨 **Modern Design**: Material Design 3 mit Dark Mode Support
- 🔋 **Ressourcenschonend**: Optimiert für minimalen Akkuverbrauch
- 🔒 **Datenschutz**: Alle Daten bleiben lokal auf Ihrem Gerät
- 🚀 **Schnell & Zuverlässig**: Sofortige Reaktion beim App-Start

## 📸 Screenshots

[Coming soon]

## 🚀 Schnellstart

### Voraussetzungen

- Android-Gerät mit Android 6.0 (API 23) oder höher
- Fingerabdruck-Sensor oder andere biometrische Authentifizierung
- Flutter SDK installiert (für Entwicklung)

### Installation für Entwickler

```bash
# Repository klonen
git clone https://github.com/your-username/AppLocker-on-Android.git
cd AppLocker-on-Android

# Dependencies installieren
flutter pub get

# App auf verbundenem Gerät starten
flutter run
```

### Installation für Endbenutzer

1. Laden Sie die neueste APK aus den [Releases](https://github.com/your-username/AppLocker-on-Android/releases)
2. Installieren Sie die APK auf Ihrem Android-Gerät
3. Erteilen Sie die erforderlichen Berechtigungen
4. Starten Sie die App und sperren Sie gewünschte Apps

## 📚 Dokumentation

- **[Setup-Anleitung](SETUP.md)** - Detaillierte Installation und Konfiguration
- **[Features & Funktionalität](FEATURES.md)** - Vollständige Feature-Liste und technische Details

## 🎯 Verwendung

### 1. Erste Einrichtung

Beim ersten Start werden Sie aufgefordert, folgende Berechtigungen zu erteilen:

- **App-Nutzungszugriff**: Erkennt, wann Apps gestartet werden
- **Über anderen Apps anzeigen**: Zeigt den Lock-Screen an

### 2. Apps sperren

1. Öffnen Sie AppLocker
2. Durchsuchen Sie die Liste der installierten Apps
3. Aktivieren Sie den Schalter neben den Apps, die Sie sperren möchten
4. Fertig! Die Apps sind jetzt gesperrt

### 3. Gesperrte Apps öffnen

1. Starten Sie eine gesperrte App
2. Der Lock-Screen erscheint automatisch
3. Authentifizieren Sie sich mit Ihrem Fingerabdruck
4. Die App wird geöffnet

## 🛠️ Technologie-Stack

- **Flutter** - Cross-platform UI Framework
- **Dart** - Programmiersprache
- **Kotlin** - Android native Komponenten
- **Material Design 3** - UI Design System

### Verwendete Packages

- `local_auth` - Biometrische Authentifizierung
- `installed_apps` - App-Liste abrufen
- `shared_preferences` - Lokale Datenspeicherung
- `permission_handler` - Berechtigungsverwaltung

## 🔐 Berechtigungen

Die App benötigt folgende Berechtigungen:

| Berechtigung | Zweck |
|--------------|-------|
| USE_BIOMETRIC | Fingerabdruck-Authentifizierung |
| QUERY_ALL_PACKAGES | Liste installierter Apps abrufen |
| PACKAGE_USAGE_STATS | App-Starts erkennen |
| SYSTEM_ALERT_WINDOW | Lock-Screen über Apps anzeigen |
| FOREGROUND_SERVICE | Hintergrund-Überwachung |

## 🏗️ Projektstruktur

```
AppLocker-on-Android/
├── lib/
│   ├── main.dart                    # App-Einstiegspunkt
│   ├── models/
│   │   └── app_info.dart           # App-Datenmodell
│   ├── screens/
│   │   ├── permissions_screen.dart # Berechtigungs-Setup
│   │   ├── home_screen.dart        # Haupt-App-Liste
│   │   └── lock_screen.dart        # Lock-Screen
│   └── services/
│       ├── auth_service.dart       # Authentifizierung
│       ├── app_lock_service.dart   # App-Sperr-Logik
│       └── platform_service.dart   # Platform Channel
├── android/
│   └── app/src/main/kotlin/
│       ├── MainActivity.kt         # Haupt-Activity
│       └── AppMonitorService.kt    # Überwachungs-Service
├── SETUP.md                        # Setup-Anleitung
├── FEATURES.md                     # Feature-Dokumentation
└── README.md                       # Diese Datei
```

## 🤝 Beitragen

Beiträge sind willkommen! Hier ist, wie Sie helfen können:

1. 🍴 Forken Sie das Repository
2. 🌱 Erstellen Sie einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. ✅ Committen Sie Ihre Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Pushen Sie zum Branch (`git push origin feature/AmazingFeature`)
5. 🎉 Öffnen Sie einen Pull Request

## 🐛 Probleme melden

Haben Sie einen Bug gefunden? Öffnen Sie ein [Issue](https://github.com/your-username/AppLocker-on-Android/issues) und beschreiben Sie:

- Was ist passiert?
- Was sollte passieren?
- Schritte zur Reproduktion
- Screenshots (falls relevant)
- Android-Version und Gerätemodell

## 📋 Roadmap

- [ ] Zeitbasierte App-Sperrung
- [ ] App-Kategorien und Gruppen
- [ ] Statistiken über gesperrte Zugriffe
- [ ] Widget für schnellen Zugriff
- [ ] Profil-System (Arbeit, Privat, etc.)
- [ ] PIN/Muster als Alternative

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe die [LICENSE](LICENSE) Datei für Details.

## 👨‍💻 Autor

Erstellt mit ❤️ und Flutter

## 🙏 Danksagungen

- Flutter Team für das großartige Framework
- Android Community für Hilfe und Unterstützung
- Alle Contributor und Tester

---

<div align="center">
  <p>Wenn Ihnen dieses Projekt gefällt, geben Sie ihm einen ⭐️</p>
  <p>Made with Flutter 💙</p>
</div>
