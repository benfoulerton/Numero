package com.numero.app.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import com.numero.app.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Numero widget — medium 2×2 variant.
 *
 * Adds the next lesson title alongside streak and XP. Spec §13.3.
 */
class NumeroWidgetMedium : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = HomeWidgetPlugin.getData(context)
        val streak = prefs.getInt("streak", 0)
        val xpToday = prefs.getInt("xpToday", 0)
        val nextLessonTitle = prefs.getString("nextLessonTitle", "Start learning")
            ?: "Start learning"

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.numero_widget_medium)
            views.setTextViewText(R.id.widget_streak_value_m, streak.toString())
            views.setTextViewText(R.id.widget_xp_value_m, xpToday.toString())
            views.setTextViewText(R.id.widget_next_lesson_title, nextLessonTitle)

            val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                com.numero.app.MainActivity::class.java,
                android.net.Uri.parse("numero://lesson/next")
            )
            views.setOnClickPendingIntent(R.id.widget_root_medium, pendingIntent)

            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
