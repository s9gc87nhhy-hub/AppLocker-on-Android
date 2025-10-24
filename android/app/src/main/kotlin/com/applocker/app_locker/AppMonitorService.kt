package com.applocker.app_locker

import android.app.*
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat

/**
 * Foreground Service zur Überwachung von App-Starts
 * Dieser Service läuft im Hintergrund und prüft, welche Apps gestartet werden
 */
class AppMonitorService : Service() {
    private val CHANNEL_ID = "AppLockerServiceChannel"
    private val NOTIFICATION_ID = 1
    private val CHECK_INTERVAL = 1000L // Prüfe alle 1 Sekunde

    private lateinit var handler: Handler
    private lateinit var checkRunnable: Runnable
    private var lastCheckedTime = System.currentTimeMillis()

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        handler = Handler(Looper.getMainLooper())
        setupMonitoring()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)

        // Starte die Überwachung
        handler.post(checkRunnable)

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(checkRunnable)
    }

    /**
     * Richtet die App-Überwachung ein
     */
    private fun setupMonitoring() {
        checkRunnable = object : Runnable {
            override fun run() {
                checkForLockedApps()
                handler.postDelayed(this, CHECK_INTERVAL)
            }
        }
    }

    /**
     * Prüft, ob eine gesperrte App gestartet wurde
     */
    private fun checkForLockedApps() {
        val currentTime = System.currentTimeMillis()
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val events = usageStatsManager.queryEvents(lastCheckedTime, currentTime)
        val event = UsageEvents.Event()

        while (events.hasNextEvent()) {
            events.getNextEvent(event)

            // Prüfe auf MOVE_TO_FOREGROUND Events
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                val packageName = event.packageName

                // Ignoriere unsere eigene App
                if (packageName != this.packageName) {
                    // Prüfe, ob die App gesperrt ist
                    if (isAppLocked(packageName)) {
                        // Zeige Lock-Screen
                        showLockScreen(packageName)
                    }
                }
            }
        }

        lastCheckedTime = currentTime
    }

    /**
     * Prüft, ob eine App gesperrt ist
     */
    private fun isAppLocked(packageName: String): Boolean {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val lockedApps = prefs.getStringSet("flutter.locked_apps", setOf()) ?: setOf()
        return lockedApps.contains(packageName)
    }

    /**
     * Zeigt den Lock-Screen für die gesperrte App an
     */
    private fun showLockScreen(packageName: String) {
        // Bringe unsere App in den Vordergrund
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("locked_app_package", packageName)
            putExtra("show_lock_screen", true)
        }
        startActivity(intent)
    }

    /**
     * Erstellt den Notification Channel für Android O und höher
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "AppLocker Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Überwacht gesperrte Apps im Hintergrund"
                setShowBadge(false)
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    /**
     * Erstellt die Notification für den Foreground Service
     */
    private fun createNotification(): Notification {
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("AppLocker aktiv")
            .setContentText("Überwacht gesperrte Apps")
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }
}
