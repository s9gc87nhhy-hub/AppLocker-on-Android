package com.applocker.app_locker

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.applocker.app_locker/permissions"
    private val LOCK_CHANNEL = "com.applocker.app_locker/lock_screen"
    private val USAGE_STATS_REQUEST_CODE = 1001
    private val SYSTEM_ALERT_WINDOW_REQUEST_CODE = 1002

    private var lockScreenMethodChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkUsageStatsPermission" -> {
                    result.success(hasUsageStatsPermission())
                }
                "requestUsageStatsPermission" -> {
                    requestUsageStatsPermission()
                    result.success(null)
                }
                "checkSystemAlertWindowPermission" -> {
                    result.success(hasSystemAlertWindowPermission())
                }
                "requestSystemAlertWindowPermission" -> {
                    requestSystemAlertWindowPermission()
                    result.success(null)
                }
                "startMonitoringService" -> {
                    startAppMonitorService()
                    result.success(true)
                }
                "stopMonitoringService" -> {
                    stopAppMonitorService()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Setup lock screen method channel
        lockScreenMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOCK_CHANNEL)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleLockScreenIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleLockScreenIntent(intent)
    }

    /**
     * Verarbeitet Intents vom AppMonitorService, um Lock Screen anzuzeigen
     */
    private fun handleLockScreenIntent(intent: Intent?) {
        intent?.let {
            val showLockScreen = it.getBooleanExtra("show_lock_screen", false)
            val packageName = it.getStringExtra("locked_app_package")

            if (showLockScreen && !packageName.isNullOrEmpty()) {
                // Sende Daten an Flutter, um Lock Screen anzuzeigen
                lockScreenMethodChannel?.invokeMethod("showLockScreen", mapOf(
                    "packageName" to packageName
                ))
            }
        }
    }

    /**
     * Prüft, ob die PACKAGE_USAGE_STATS Berechtigung erteilt wurde
     */
    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    /**
     * Fordert die PACKAGE_USAGE_STATS Berechtigung an
     */
    private fun requestUsageStatsPermission() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        intent.data = Uri.parse("package:$packageName")
        startActivityForResult(intent, USAGE_STATS_REQUEST_CODE)
    }

    /**
     * Prüft, ob die SYSTEM_ALERT_WINDOW Berechtigung erteilt wurde
     */
    private fun hasSystemAlertWindowPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }
    }

    /**
     * Fordert die SYSTEM_ALERT_WINDOW Berechtigung an
     */
    private fun requestSystemAlertWindowPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, SYSTEM_ALERT_WINDOW_REQUEST_CODE)
        }
    }

    /**
     * Startet den App-Überwachungsservice
     */
    private fun startAppMonitorService() {
        val serviceIntent = Intent(this, AppMonitorService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }

    /**
     * Stoppt den App-Überwachungsservice
     */
    private fun stopAppMonitorService() {
        val serviceIntent = Intent(this, AppMonitorService::class.java)
        stopService(serviceIntent)
    }
}
