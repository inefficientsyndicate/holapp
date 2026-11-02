package com.example.holapp

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

open class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "holapp/app_icon")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getIcon" -> result.success(currentIcon())
                    "setIcon" -> {
                        val name = call.arguments as? String
                        if (name != null && name in launcherEntries) {
                            setIcon(name)
                            result.success(null)
                        } else {
                            result.error("unknown_icon", null, name)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun component(className: String) =
        ComponentName(this, "com.example.holapp.$className")

    private fun currentIcon(): String =
        launcherEntries.entries.firstOrNull { (name, className) ->
            name != DEFAULT_ICON &&
                packageManager.getComponentEnabledSetting(component(className)) ==
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
        }?.key ?: DEFAULT_ICON

    // Enables the new launcher entry first, so there is never a moment with none.
    private fun setIcon(name: String) {
        val (selected, others) = launcherEntries.entries.partition { it.key == name }
        for ((entries, state) in listOf(
            selected to PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            others to PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
        )) {
            for (entry in entries) {
                packageManager.setComponentEnabledSetting(
                    component(entry.value),
                    state,
                    PackageManager.DONT_KILL_APP,
                )
            }
        }
    }

    private companion object {
        const val DEFAULT_ICON = "midnight"

        // Dart variant name -> launcher entry in AndroidManifest.xml.
        val launcherEntries = mapOf(
            DEFAULT_ICON to "MainActivity",
            "light" to "IconLight",
            "green" to "IconGreen",
        )
    }
}

/**
 * What the alternate icons' aliases launch. They can't target [MainActivity],
 * which is disabled while one of them is selected.
 */
class AlternateIconActivity : MainActivity()
