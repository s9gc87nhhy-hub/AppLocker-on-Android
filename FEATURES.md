# AppLocker - Features und Funktionalität

## Hauptfunktionen

### 1. App-Sperre mit Fingerabdruck

- **Biometrische Authentifizierung**: Sichern Sie Ihre Apps mit Fingerabdruck oder anderen biometrischen Methoden
- **Schnelle Authentifizierung**: Entsperren Sie Apps in Sekundenschnelle
- **Fallback-Optionen**: Nutzen Sie PIN/Muster als Alternative

### 2. Flexible App-Verwaltung

- **Selektive Sperrung**: Wählen Sie gezielt Apps aus, die gesperrt werden sollen
- **Echtzeit-Suche**: Finden Sie Apps schnell mit der integrierten Suchfunktion
- **Übersichtliche Liste**: Alle Apps alphabetisch sortiert mit Icons
- **Ein-Klick-Sperrung**: Apps mit einem Schalter sperren/entsperren

### 3. Intelligente Überwachung

- **Hintergrund-Service**: Überwacht kontinuierlich App-Starts
- **Geringer Ressourcenverbrauch**: Optimiert für minimalen Akkuverbrauch
- **Zuverlässige Erkennung**: Erkennt sofort, wenn eine gesperrte App gestartet wird
- **Foreground Service**: Läuft stabil im Hintergrund

### 4. Benutzerfreundliche Oberfläche

- **Material Design 3**: Moderne, intuitive Benutzeroberfläche
- **Dark Mode**: Automatische Anpassung an Systemeinstellungen
- **Statistiken**: Übersicht über gesperrte Apps und Status
- **Animationen**: Flüssige Übergänge und Feedback

### 5. Sicherheit und Datenschutz

- **Lokale Speicherung**: Alle Daten bleiben auf Ihrem Gerät
- **Keine Cloud**: Keine Datenübertragung an externe Server
- **Verschlüsselte Einstellungen**: Sichere Speicherung der App-Einstellungen
- **Open Source**: Transparenter, prüfbarer Code

## Technische Details

### Unterstützte Android-Versionen
- Minimum: Android 6.0 (API 23)
- Empfohlen: Android 8.0 (API 26) oder höher
- Getestet bis: Android 14 (API 34)

### Erforderliche Berechtigungen

#### 1. USE_BIOMETRIC / USE_FINGERPRINT
- **Zweck**: Biometrische Authentifizierung durchführen
- **Verwendung**: Fingerabdruck scannen für App-Entsperrung

#### 2. QUERY_ALL_PACKAGES
- **Zweck**: Liste aller installierten Apps abrufen
- **Verwendung**: App-Liste anzeigen und verwalten

#### 3. PACKAGE_USAGE_STATS
- **Zweck**: App-Nutzungsstatistiken abrufen
- **Verwendung**: Erkennen, wann Apps gestartet werden

#### 4. SYSTEM_ALERT_WINDOW
- **Zweck**: Fenster über anderen Apps anzeigen
- **Verwendung**: Lock-Screen über gesperrten Apps anzeigen

#### 5. FOREGROUND_SERVICE
- **Zweck**: Dienst im Vordergrund ausführen
- **Verwendung**: Kontinuierliche Überwachung im Hintergrund

### Verwendete Flutter-Packages

```yaml
local_auth: ^2.1.7              # Biometrische Authentifizierung
local_auth_android: ^1.0.34     # Android-spezifische Auth-Implementierung
shared_preferences: ^2.2.2      # Lokale Datenspeicherung
installed_apps: ^1.8.0          # Installierte Apps abrufen
permission_handler: ^11.0.1     # Berechtigungen verwalten
flutter_secure_storage: ^9.0.0  # Sichere Datenspeicherung
```

### Architektur

```
lib/
├── main.dart                    # App-Einstiegspunkt
├── models/
│   └── app_info.dart           # App-Datenmodell
├── screens/
│   ├── permissions_screen.dart # Berechtigungen-Setup
│   ├── home_screen.dart        # Haupt-App-Liste
│   └── lock_screen.dart        # Fingerabdruck-Lock-Screen
└── services/
    ├── auth_service.dart       # Authentifizierungs-Service
    ├── app_lock_service.dart   # App-Sperr-Verwaltung
    └── platform_service.dart   # Platform Channel für Android
```

### Android Native Komponenten

```
android/app/src/main/kotlin/com/applocker/app_locker/
├── MainActivity.kt             # Haupt-Activity mit Platform Channels
└── AppMonitorService.kt        # Foreground Service für Überwachung
```

## Geplante Features (Roadmap)

### Version 1.1
- [ ] Zeitbasierte Sperrung (z.B. nur nachts)
- [ ] App-Kategorien (Soziale Medien, Games, etc.)
- [ ] Mehrfach-Auswahl für schnelles Sperren/Entsperren
- [ ] Statistiken über gesperrte App-Zugriffe

### Version 1.2
- [ ] Widget für schnellen Zugriff
- [ ] Profil-System (Arbeit, Privat, etc.)
- [ ] Intruder-Selfie bei fehlgeschlagener Authentifizierung
- [ ] Benachrichtigungen bei Sperrvorgängen

### Version 2.0
- [ ] PIN/Muster als alternative Authentifizierungsmethode
- [ ] Fake-Crash-Screen als Tarnung
- [ ] Cloud-Backup der Einstellungen (optional)
- [ ] Themenwechsel und Personalisierung

## Performance-Optimierungen

- **Lazy Loading**: App-Icons werden nur bei Bedarf geladen
- **Caching**: Häufig verwendete Daten werden zwischengespeichert
- **Effiziente Überwachung**: Minimale Systemressourcen im Hintergrund
- **Optimierte UI**: Flüssige 60 FPS Animationen

## Sicherheitsmaßnahmen

1. **Keine Root-Anforderungen**: Funktioniert auf allen Geräten
2. **Tamper-Protection**: Schutz vor Deinstallation durch andere Apps
3. **Sichere Speicherung**: Verschlüsselte Einstellungen
4. **Biometrische Sicherheit**: Nutzt Android Keystore System

## Einschränkungen

1. **System-Apps**: Können nicht gesperrt werden (Android-Einschränkung)
2. **Android 11+**: Zusätzliche Schritte für QUERY_ALL_PACKAGES erforderlich
3. **Battery Optimization**: Muss für zuverlässige Funktion deaktiviert werden
4. **OEM-Spezifisch**: Einige Hersteller haben zusätzliche Einschränkungen

## Bekannte Probleme und Lösungen

### Problem: Service wird beendet
**Ursache**: Aggressive Akku-Optimierung
**Lösung**: Deaktivieren Sie die Akku-Optimierung für AppLocker

### Problem: Apps werden nicht erkannt
**Ursache**: Fehlende PACKAGE_USAGE_STATS Berechtigung
**Lösung**: Erteilen Sie die Berechtigung in den Systemeinstellungen

### Problem: Lock-Screen reagiert nicht
**Ursache**: SYSTEM_ALERT_WINDOW Berechtigung fehlt
**Lösung**: Aktivieren Sie "Über anderen Apps anzeigen"

## Vergleich mit anderen App-Lockern

| Feature | AppLocker | Andere |
|---------|-----------|--------|
| Open Source | ✓ | ✗ |
| Keine Werbung | ✓ | ✗ |
| Lokale Speicherung | ✓ | ~✗ |
| Material Design 3 | ✓ | ✗ |
| Flutter-basiert | ✓ | ✗ |
| Minimale Berechtigungen | ✓ | ✗ |

## Beitragen

Möchten Sie zur Entwicklung beitragen?

1. Fork das Repository
2. Erstellen Sie einen Feature-Branch
3. Implementieren Sie Ihre Änderungen
4. Erstellen Sie einen Pull Request

Siehe auch CONTRIBUTING.md für detaillierte Richtlinien.

## Lizenz

[Fügen Sie hier Ihre Lizenz ein]

## Credits

Entwickelt mit Flutter und Liebe zum Detail.
