# AppLocker Setup-Anleitung

## Voraussetzungen

1. **Flutter SDK** installiert (empfohlen: Version 3.0 oder höher)
2. **Android Studio** oder **VS Code** mit Flutter-Plugin
3. Ein **Android-Gerät** mit:
   - Android 6.0 (API 23) oder höher
   - Fingerabdruck-Sensor oder biometrische Authentifizierung
   - USB-Debugging aktiviert

## Installation

### 1. Repository klonen

```bash
git clone <repository-url>
cd AppLocker-on-Android
```

### 2. Dependencies installieren

```bash
flutter pub get
```

### 3. Android-Gerät verbinden

- Verbinden Sie Ihr Android-Gerät via USB
- Aktivieren Sie USB-Debugging in den Entwickleroptionen
- Prüfen Sie die Verbindung:

```bash
flutter devices
```

### 4. App starten

```bash
flutter run
```

## Erste Schritte nach der Installation

### 1. Berechtigungen erteilen

Beim ersten Start fordert die App folgende Berechtigungen an:

#### a) App-Nutzungszugriff
- Diese Berechtigung erlaubt der App, zu erkennen, wann andere Apps gestartet werden
- **So erteilen Sie die Berechtigung:**
  1. Tippen Sie auf "Berechtigung erteilen"
  2. Finden Sie "AppLocker" in der Liste
  3. Aktivieren Sie "Zugriff auf Nutzungsdaten zulassen"

#### b) Über anderen Apps anzeigen
- Diese Berechtigung erlaubt es, den Lock-Screen über anderen Apps anzuzeigen
- **So erteilen Sie die Berechtigung:**
  1. Tippen Sie auf "Berechtigung erteilen"
  2. Finden Sie "AppLocker" in der Liste
  3. Aktivieren Sie "Über anderen Apps einblenden erlauben"

### 2. Fingerabdruck einrichten

Stellen Sie sicher, dass auf Ihrem Gerät mindestens ein Fingerabdruck registriert ist:

1. Öffnen Sie die **Einstellungen** Ihres Geräts
2. Gehen Sie zu **Sicherheit** → **Fingerabdruck**
3. Fügen Sie einen oder mehrere Fingerabdrücke hinzu

### 3. Apps sperren

1. Öffnen Sie AppLocker
2. Durchsuchen Sie die Liste der installierten Apps
3. Aktivieren Sie den Schalter neben den Apps, die Sie sperren möchten
4. Die App wird sofort gesperrt

### 4. Lock-Screen testen

- Tippen Sie auf das Fingerabdruck-Symbol in der App-Leiste
- Der Test-Lock-Screen wird angezeigt
- Authentifizieren Sie sich mit Ihrem Fingerabdruck

## Verwendung

### Apps sperren
1. Finden Sie die gewünschte App in der Liste
2. Aktivieren Sie den Schalter rechts neben dem App-Namen
3. Die App ist jetzt gesperrt

### Apps entsperren
1. Finden Sie die gesperrte App in der Liste (erkennbar am aktivierten Schalter)
2. Tippen Sie auf den Schalter
3. Authentifizieren Sie sich mit Ihrem Fingerabdruck
4. Die App ist jetzt entsperrt

### Apps durchsuchen
- Verwenden Sie das Suchfeld oben, um schnell Apps zu finden
- Die Suche funktioniert in Echtzeit

### Statistiken anzeigen
Oben auf dem Hauptbildschirm sehen Sie:
- **Apps gesamt**: Anzahl aller installierten Apps
- **Gesperrt**: Anzahl der gesperrten Apps
- **Biometrie**: Status der biometrischen Authentifizierung (✓/✗)

## Funktionsweise

### Hintergrundüberwachung

AppLocker verwendet einen Foreground Service, der:
1. Im Hintergrund läuft und App-Starts überwacht
2. Erkennt, wenn eine gesperrte App gestartet wird
3. Den Lock-Screen anzeigt, bevor die App geöffnet wird
4. Die App nur nach erfolgreicher Authentifizierung öffnet

### Datenspeicherung

Alle Daten werden lokal auf Ihrem Gerät gespeichert:
- Liste der gesperrten Apps
- Einstellungen der App
- Keine Daten werden an externe Server gesendet

## Fehlerbehebung

### Problem: Biometrie nicht verfügbar

**Lösung:**
1. Prüfen Sie, ob Ihr Gerät einen Fingerabdruck-Sensor hat
2. Stellen Sie sicher, dass mindestens ein Fingerabdruck registriert ist
3. Gehen Sie zu **Einstellungen** → **Sicherheit** → **Fingerabdruck**

### Problem: Apps werden nicht erkannt

**Lösung:**
1. Prüfen Sie, ob die "App-Nutzungszugriff"-Berechtigung erteilt wurde
2. Tippen Sie auf das Aktualisieren-Symbol (↻) in der App-Leiste
3. Starten Sie die App neu

### Problem: Lock-Screen wird nicht angezeigt

**Lösung:**
1. Prüfen Sie, ob die "Über anderen Apps anzeigen"-Berechtigung erteilt wurde
2. Starten Sie den Monitoring Service neu (App neu starten)
3. Prüfen Sie, ob die App im Hintergrund läuft

### Problem: App-Liste ist leer

**Lösung:**
1. Erteilen Sie die "Installierte Apps abfragen"-Berechtigung
2. Starten Sie die App neu
3. Tippen Sie auf das Aktualisieren-Symbol

## Entwicklung

### Build für Release

```bash
flutter build apk --release
```

Die APK-Datei finden Sie unter: `build/app/outputs/flutter-apk/app-release.apk`

### Debug-Build

```bash
flutter build apk --debug
```

### Logs anzeigen

```bash
flutter logs
```

oder

```bash
adb logcat | grep Flutter
```

## Wichtige Hinweise

1. **Battery Optimization**: Deaktivieren Sie die Akku-Optimierung für AppLocker, damit der Monitoring Service zuverlässig läuft
2. **Autostart**: Aktivieren Sie Autostart für AppLocker in den Geräteeinstellungen
3. **Permissions**: Alle Berechtigungen müssen erteilt sein, damit die App ordnungsgemäß funktioniert

## Support

Bei Problemen oder Fragen:
1. Prüfen Sie die Logs: `flutter logs`
2. Überprüfen Sie die Berechtigungen
3. Starten Sie die App neu
4. Erstellen Sie ein Issue im Repository
