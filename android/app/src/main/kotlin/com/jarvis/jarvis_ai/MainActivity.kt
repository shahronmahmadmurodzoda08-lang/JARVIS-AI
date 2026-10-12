package com.jarvis.jarvis_ai

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Android tools-и JARVIS. Танҳо API-ҳои расмии Android истифода мешаванд,
 * ҳеҷ иҷозати хатарнок талаб намешавад.
 *
 * Номи channel бояд бо lib/android_tools/platform_bridge.dart мувофиқ бошад.
 */
class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    handle(call, result)
                } catch (e: Exception) {
                    result.error("tool_error", e.message, null)
                }
            }
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getBatteryStatus" -> result.success(batteryStatus())
            "getVolume" -> result.success(mapOf("percent" to volumePercent()))
            "setVolume" -> {
                val percent = call.argument<Int>("percent")
                if (percent == null) {
                    result.error("bad_args", "percent is required", null)
                } else {
                    setVolume(percent)
                    result.success(null)
                }
            }
            "getDeviceInfo" -> result.success(deviceInfo())
            "getNetworkStatus" -> result.success(networkStatus())
            "openSystemSettings" -> {
                openSystemSettings()
                result.success(null)
            }
            "openApplicationSettings" -> {
                openApplicationSettings()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun batteryStatus(): Map<String, Any> {
        val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1

        val percent = if (level >= 0 && scale > 0) level * 100 / scale else -1
        val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
            status == BatteryManager.BATTERY_STATUS_FULL

        return mapOf("percent" to percent, "charging" to charging)
    }

    private fun audioManager(): AudioManager =
        getSystemService(Context.AUDIO_SERVICE) as AudioManager

    private fun volumePercent(): Int {
        val audio = audioManager()
        val max = audio.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val current = audio.getStreamVolume(AudioManager.STREAM_MUSIC)
        return if (max > 0) current * 100 / max else 0
    }

    private fun setVolume(percent: Int) {
        val audio = audioManager()
        val max = audio.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val target = Math.round(percent.coerceIn(0, 100) * max / 100.0).toInt()
        audio.setStreamVolume(AudioManager.STREAM_MUSIC, target, AudioManager.FLAG_SHOW_UI)
    }

    private fun deviceInfo(): Map<String, Any> = mapOf(
        "manufacturer" to Build.MANUFACTURER,
        "model" to Build.MODEL,
        "androidVersion" to Build.VERSION.RELEASE,
        "sdk" to Build.VERSION.SDK_INT
    )

    private fun networkStatus(): Map<String, Any> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return mapOf("connected" to false, "type" to "unknown")
        }

        val manager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val caps = manager.getNetworkCapabilities(manager.activeNetwork)
        val connected = caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
        val type = when {
            caps == null -> "none"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "cellular"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "ethernet"
            else -> "other"
        }
        return mapOf("connected" to connected, "type" to type)
    }

    private fun openSystemSettings() {
        startActivity(Intent(Settings.ACTION_SETTINGS))
    }

    private fun openApplicationSettings() {
        val intent = Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.fromParts("package", packageName, null)
        )
        startActivity(intent)
    }

    companion object {
        private const val CHANNEL = "com.jarvis.jarvis_ai/tools"
    }
}
