package com.numero.app.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.numero.app.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Numero widget — small 1×1 variant.
 *
 * Displays the user's current streak count and today's XP, with a tap-to-launch
 * deep link that opens directly into the next lesson.
 * Spec §13.3.
 */
class NumeroWidgetSmall : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs: SharedPreferences = HomeWidgetPlugin.getData(context)
        val streak = prefs.getInt("streak", 0)
        val xpToday = prefs.getInt("xpToday", 0)

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.numero_widget_small)
            views.setTextViewText(R.id.widget_streak_value, streak.toString())
            views.setTextViewText(R.id.widget_xp_value, xpToday.toString())

            val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                com.numero.app.MainActivity::class.java,
                android.net.Uri.parse("numero://lesson/next")
            )
            views.setOnClickPendingIntent(R.id.widget_root_small, pendingIntent)

            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
