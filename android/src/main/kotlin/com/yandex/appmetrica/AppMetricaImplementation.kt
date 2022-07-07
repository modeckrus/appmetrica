/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.yandex.android.metrica.flutter.pigeon.Pigeon
import com.yandex.metrica.AppMetricaDeviceIDListener
import com.yandex.metrica.DeferredDeeplinkListener
import com.yandex.metrica.DeferredDeeplinkParametersListener
import com.yandex.metrica.ReporterConfig
import com.yandex.metrica.YandexMetrica

class AppMetricaImplementation(private val context: Context): Pigeon.AppMetricaPigeon {

    private val mainHandler = Handler(Looper.getMainLooper())

    var activity: Activity? = null

    override fun activate(config: Pigeon.AppMetricaConfigPigeon) {
        YandexMetrica.activate(context, config.toNative())
    }

    override fun activateReporter(config: Pigeon.ReporterConfigPigeon) {
        YandexMetrica.activateReporter(context, ReporterConfig.newConfigBuilder(config.apiKey).apply {
            config.logs?.takeIf { it }?.let { withLogs() }
            config.maxReportsInDatabaseCount?.toInt()?.let(::withMaxReportsInDatabaseCount)
            config.sessionTimeout?.toInt()?.let(::withSessionTimeout)
            config.statisticsSending?.let(::withStatisticsSending)
            config.userProfileID?.let(::withUserProfileID)
        }.build())
    }

    override fun touchReporter(apiKey: String) {
        YandexMetrica.getReporter(context, apiKey)
    }

    override fun getLibraryApiLevel(): Long {
        return YandexMetrica.getLibraryApiLevel().toLong()
    }

    override fun getLibraryVersion(): String {
        return YandexMetrica.getLibraryVersion()
    }

    override fun resumeSession() {
        YandexMetrica.resumeSession(activity)
    }

    override fun pauseSession() {
        YandexMetrica.pauseSession(activity)
    }

    override fun reportAppOpen(deeplink: Pigeon.StringPigeonWrapper) {
        YandexMetrica.reportAppOpen(deeplink.stringPigeon)
    }

    override fun reportError(error: Pigeon.ErrorDetailsPigeon, message: Pigeon.StringPigeonWrapper) {
        YandexMetrica.getPluginExtension().reportError(error.toNativeNotNull(), message.stringPigeon)
    }

    override fun reportErrorWithGroup(groupId: String, error: Pigeon.ErrorDetailsPigeon, message: Pigeon.StringPigeonWrapper) {
        YandexMetrica.getPluginExtension().reportError(groupId, message.stringPigeon, error.toNative())
    }

    override fun reportUnhandledException(error: Pigeon.ErrorDetailsPigeon) {
        YandexMetrica.getPluginExtension().reportUnhandledException(error.toNativeNotNull())
    }

    override fun reportEventWithJson(eventName: String, attributesJson: Pigeon.StringPigeonWrapper) {
        YandexMetrica.reportEvent(eventName, attributesJson.stringPigeon)
    }

    override fun reportEvent(eventName: String) {
        YandexMetrica.reportEvent(eventName)
    }

    override fun reportReferralUrl(referralUrl: String) {
        YandexMetrica.reportReferralUrl(referralUrl)
    }

    override fun requestDeferredDeeplink(result: Pigeon.Result<Pigeon.AppMetricaDeferredDeeplinkPigeon>) {
        YandexMetrica.requestDeferredDeeplink(object: DeferredDeeplinkListener {
            override fun onDeeplinkLoaded(deeplink: String) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkPigeon().apply {
                        this.deeplink = deeplink
                    })
                }
            }

            override fun onError(error: DeferredDeeplinkListener.Error, messageArg: String?) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkPigeon().apply {
                        this.deeplink = null
                        this.error = Pigeon.AppMetricaDeferredDeeplinkErrorPigeon().apply {
                            reason = when (error) {
                                DeferredDeeplinkListener.Error.NOT_A_FIRST_LAUNCH -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH
                                DeferredDeeplinkListener.Error.PARSE_ERROR -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR
                                DeferredDeeplinkListener.Error.UNKNOWN -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN
                                DeferredDeeplinkListener.Error.NO_REFERRER -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER
                            }
                            message = messageArg
                            description = error.description
                        }
                    })
                }
            }
        })
    }

    override fun requestDeferredDeeplinkParameters(result: Pigeon.Result<Pigeon.AppMetricaDeferredDeeplinkParametersPigeon>) {
        YandexMetrica.requestDeferredDeeplinkParameters(object: DeferredDeeplinkParametersListener {
            override fun onParametersLoaded(p0: MutableMap<String, String>) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkParametersPigeon().apply {
                        this.parameters = p0.toMap()
                    })
                }
            }

            override fun onError(p0: DeferredDeeplinkParametersListener.Error, p1: String) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkParametersPigeon().apply {
                        this.parameters = null
                        this.error = Pigeon.AppMetricaDeferredDeeplinkErrorPigeon().apply {
//                            reason = when (error) {
//                                DeferredDeeplinkParametersListener.Error.NOT_A_FIRST_LAUNCH -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH
//                                DeferredDeeplinkParametersListener.Error.PARSE_ERROR -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR
//                                DeferredDeeplinkParametersListener.Error.UNKNOWN -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN
//                                DeferredDeeplinkParametersListener.Error.NO_REFERRER -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER
//                            }
//                            message = messageArg
                            description = error.description
                        }
                    })
                }
            }

        });
//        YandexMetrica.requestDeferredDeeplinkParameters(object: DeferredDeeplinkParametersListener {
//
//            override fun onParametersLoaded(params: MutableMap<String, String>?) {
//                mainHandler.post {
//                    result.success(Pigeon.AppMetricaDeferredDeeplinkParametersPigeon().apply {
//                        this.parameters = params?.toMap()
//                    })
//                }
//            }
//
//            override fun onError(error: DeferredDeeplinkParametersListener.Error, messageArg: String?) {
//                mainHandler.post {
//                    result.success(Pigeon.AppMetricaDeferredDeeplinkParametersPigeon().apply {
//                        this.parameters = null
//                        this.error = Pigeon.AppMetricaDeferredDeeplinkErrorPigeon().apply {
//                            reason = when (error) {
//                                DeferredDeeplinkParametersListener.Error.NOT_A_FIRST_LAUNCH -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH
//                                DeferredDeeplinkParametersListener.Error.PARSE_ERROR -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR
//                                DeferredDeeplinkParametersListener.Error.UNKNOWN -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN
//                                DeferredDeeplinkParametersListener.Error.NO_REFERRER -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER
//                            }
//                            message = messageArg
//                            description = error.description
//                        }
//                    })
//                }
//            }
//        })
    }

    override fun requestAppMetricaDeviceID(result: Pigeon.Result<Pigeon.AppMetricaDeviceIdPigeon>) {
        YandexMetrica.requestAppMetricaDeviceID(object: AppMetricaDeviceIDListener {
            override fun onLoaded(deviceIdResult: String?) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeviceIdPigeon().apply {
                        deviceId = deviceIdResult
                        errorReason = Pigeon.AppMetricaDeviceIdReasonPigeon.NO_ERROR
                    })
                }
            }

            override fun onError(reason: AppMetricaDeviceIDListener.Reason) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeviceIdPigeon().apply {
                        errorReason = when (reason) {
                            AppMetricaDeviceIDListener.Reason.UNKNOWN -> Pigeon.AppMetricaDeviceIdReasonPigeon.UNKNOWN
                            AppMetricaDeviceIDListener.Reason.INVALID_RESPONSE -> Pigeon.AppMetricaDeviceIdReasonPigeon.INVALID_RESPONSE
                            AppMetricaDeviceIDListener.Reason.NETWORK -> Pigeon.AppMetricaDeviceIdReasonPigeon.NETWORK
                        }
                    })
                }
            }
        })
    }

    override fun sendEventsBuffer() {
        YandexMetrica.sendEventsBuffer()
    }

    override fun setLocation(location: Pigeon.LocationPigeon) {
        YandexMetrica.setLocation(location.takeUnless { it.isNull == true }?.toNative())
    }

    override fun setUserProfileID(userProfileID: Pigeon.StringPigeonWrapper) {
        YandexMetrica.setUserProfileID(userProfileID.stringPigeon)
    }

    override fun reportUserProfile(userProfile: Pigeon.UserProfilePigeon) {
        YandexMetrica.reportUserProfile(userProfile.toNative())
    }

    override fun putErrorEnvironmentValue(key: String, value: Pigeon.StringPigeonWrapper) {
        YandexMetrica.putErrorEnvironmentValue(key, value.stringPigeon)
    }

    override fun reportRevenue(revenue: Pigeon.RevenuePigeon) {
        YandexMetrica.reportRevenue(revenue.toNative())
    }

    override fun reportECommerce(event: Pigeon.ECommerceEventPigeon) {
        event.toNative()?.let(YandexMetrica::reportECommerce)
    }

    override fun handlePluginInitFinished() {
        YandexMetrica.resumeSession(activity)
    }

    override fun setLocationTracking(enabled: Boolean) {
        YandexMetrica.setLocationTracking(enabled)
    }

    override fun setStatisticsSending(enabled: Boolean) {
        YandexMetrica.setStatisticsSending(context, enabled)
    }
}
