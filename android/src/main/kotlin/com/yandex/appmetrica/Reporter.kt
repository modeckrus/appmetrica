/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica

import android.content.Context
import com.yandex.android.metrica.flutter.pigeon.Pigeon
import com.yandex.metrica.YandexMetrica

class Reporter(private val context: Context): Pigeon.ReporterPigeon {

    override fun sendEventsBuffer(apiKey: String) = YandexMetrica.getReporter(context, apiKey).sendEventsBuffer()

    override fun reportEvent(apiKey: String, eventName: String) =
        YandexMetrica.getReporter(context, apiKey).reportEvent(eventName)

    override fun reportEventWithJson(apiKey: String, eventName: String, attributesJson: Pigeon.StringPigeonWrapper) =
        YandexMetrica.getReporter(context, apiKey).reportEvent(eventName, attributesJson.stringPigeon)

    override fun reportError(apiKey: String, error: Pigeon.ErrorDetailsPigeon, message: Pigeon.StringPigeonWrapper) {
        YandexMetrica.getReporter(context, apiKey).pluginExtension.reportError(error.toNativeNotNull(), message.stringPigeon)
    }

    override fun reportErrorWithGroup(apiKey: String, groupId: String, error: Pigeon.ErrorDetailsPigeon, message: Pigeon.StringPigeonWrapper) {
        YandexMetrica.getReporter(context, apiKey).pluginExtension.reportError(groupId, message.stringPigeon, error.toNative())
    }

    override fun reportUnhandledException(apiKey: String, error: Pigeon.ErrorDetailsPigeon) {
        YandexMetrica.getReporter(context, apiKey).pluginExtension.reportUnhandledException(error.toNativeNotNull())
    }

    override fun resumeSession(apiKey: String) = YandexMetrica.getReporter(context, apiKey).resumeSession()

    override fun pauseSession(apiKey: String) = YandexMetrica.getReporter(context, apiKey).pauseSession()

    override fun setStatisticsSending(apiKey: String, enabled: Boolean) =
        YandexMetrica.getReporter(context, apiKey).setStatisticsSending(enabled)

    override fun setUserProfileID(apiKey: String, userProfileID: Pigeon.StringPigeonWrapper) =
        YandexMetrica.getReporter(context, apiKey).setUserProfileID(userProfileID.stringPigeon)

    override fun reportUserProfile(apiKey: String, userProfile: Pigeon.UserProfilePigeon) {
        YandexMetrica.getReporter(context, apiKey).reportUserProfile(userProfile.toNative())
    }

//    override fun putErrorEnvironmentValue(apiKey: String, key: String, value: Pigeon.StringPigeonWrapper) =
//        YandexMetrica.getReporter(context, apiKey).

    override fun reportRevenue(apiKey: String, revenue: Pigeon.RevenuePigeon) =
        YandexMetrica.getReporter(context, apiKey).reportRevenue(revenue.toNative())

    override fun reportECommerce(apiKey: String, event: Pigeon.ECommerceEventPigeon) {
        event.toNative()?.let(YandexMetrica.getReporter(context, apiKey)::reportECommerce)
    }
}
