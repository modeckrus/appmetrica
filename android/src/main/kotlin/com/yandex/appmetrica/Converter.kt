/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica

import android.location.Location
import com.yandex.android.metrica.flutter.pigeon.Pigeon
import com.yandex.metrica.PreloadInfo
import com.yandex.metrica.Revenue
import com.yandex.metrica.YandexMetricaConfig
import com.yandex.metrica.plugins.PluginErrorDetails
import com.yandex.metrica.plugins.StackTraceItem
import com.yandex.metrica.profile.Attribute
import com.yandex.metrica.profile.GenderAttribute
import com.yandex.metrica.profile.UserProfile
import java.math.BigDecimal
import java.util.Currency

internal fun Pigeon.RevenuePigeon.toNative() = Revenue.newBuilderWithMicros(
    (BigDecimal(price) * BigDecimal(1_000_000)).toLong(),
    Currency.getInstance(currency)
).apply {
    productId?.let(::withProductID)
    payload?.let(::withPayload)
    quantity?.toInt()?.let(::withQuantity)
    receipt?.takeIf{ it.isNull != true }?.let { receipt ->
        withReceipt(Revenue.Receipt.newBuilder().apply {
            receipt.data?.let(::withData)
            receipt.signature?.let(::withSignature)
        }.build())
    }
}.build()

internal fun Pigeon.AppMetricaConfigPigeon.toNative() = YandexMetricaConfig.newConfigBuilder(apiKey)
    .apply {
        appVersion?.let(::withAppVersion)
        crashReporting?.let(::withCrashReporting)
        firstActivationAsUpdate?.let(::handleFirstActivationAsUpdate)
        location?.takeUnless { it.isNull == true }?.toNative()?.let(::withLocation)
        locationTracking?.let(::withLocationTracking)
        logs?.takeIf { it }?.let { withLogs() }
        maxReportsInDatabaseCount?.toInt()?.let(::withMaxReportsInDatabaseCount)
        nativeCrashReporting?.let(::withNativeCrashReporting)
        sessionTimeout?.toInt()?.let(::withSessionTimeout)
        sessionsAutoTracking?.let(::withSessionsAutoTrackingEnabled)
        statisticsSending?.let(::withStatisticsSending)
        preloadInfo?.takeUnless { it.isNull == true }?.let { preload ->
            withPreloadInfo(
                PreloadInfo.newBuilder(preload.trackingId).apply {
                    preload.additionalInfo?.forEach { entry ->
                        setAdditionalParams(entry.key as String, entry.value as String)
                    }
                }.build()
            )
        }
        errorEnvironment?.forEach { (key, value) -> withErrorEnvironmentValue(key, value) }
        userProfileID?.let(::withUserProfileID)
        revenueAutoTracking?.let(::withRevenueAutoTrackingEnabled)
        withAppOpenTrackingEnabled(false)
    }.build()

internal fun Pigeon.LocationPigeon.toNative() = Location(provider).also { output ->
    output.longitude = longitude
    output.latitude = latitude
    altitude?.let(output::setAltitude)
    course?.toFloat()?.let(output::setBearing)
    timestamp?.let(output::setTime)
    accuracy?.toFloat()?.let(output::setAccuracy)
    speed?.toFloat()?.let(output::setSpeed)
}

internal fun Pigeon.UserProfilePigeon.toNative(): UserProfile {
    val builder = UserProfile.newBuilder()
    attributes.map { attribute ->
        when (attribute.type) {
            Pigeon.UserProfileAttributeType.BIRTH_DATE -> {
                val birthdate = Attribute.birthDate()
                if (attribute.reset) {
                    birthdate.withValueReset();
                } else {
                    val year = attribute.year
                    val month = attribute.month
                    val day = attribute.day
                    val age = attribute.age
                    return@map if (year == null) {
                        if (age != null) {
                            birthdate.withAge(age.toInt())
                        } else {
                            null
                        }
                    } else {
                        if (month == null) {
                            birthdate.withBirthDate(year.toInt())
                        } else {
                            if (day == null) {
                                birthdate.withBirthDate(year.toInt(), month.toInt())
                            } else {
                                birthdate.withBirthDate(year.toInt(), month.toInt(), day.toInt())
                            }
                        }
                    }

                }
            }
            Pigeon.UserProfileAttributeType.BOOLEAN -> {
                val boolean = Attribute.customBoolean(attribute.key)
                if (attribute.reset) {
                    boolean.withValueReset();
                } else {
                    if (attribute.ifUndefined) {
                        boolean.withValueIfUndefined(attribute.boolValue)
                    } else {
                        boolean.withValue(attribute.boolValue)
                    }
                }
            }
            Pigeon.UserProfileAttributeType.COUNTER -> {
                val counter = Attribute.customCounter(attribute.key)
                counter.withDelta(attribute.doubleValue)
            }
            Pigeon.UserProfileAttributeType.GENDER -> {
                val gender = Attribute.gender()
                if (attribute.reset) {
                    gender.withValueReset();
                } else {
                    gender.withValue(genderToNative[attribute.genderValue]!!)
                }
            }
            Pigeon.UserProfileAttributeType.NAME -> {
                val name = Attribute.name()
                if (attribute.reset) {
                    name.withValueReset();
                } else {
                    name.withValue(attribute.stringValue)
                }
            }
            Pigeon.UserProfileAttributeType.NOTIFICATION_ENABLED -> {
                val notigification = Attribute.notificationsEnabled()
                if (attribute.reset) {
                    notigification.withValueReset();
                } else {
                    notigification.withValue(attribute.boolValue)
                }
            }
            Pigeon.UserProfileAttributeType.NUMBER -> {
                val number = Attribute.customNumber(attribute.key)
                if (attribute.reset) {
                    number.withValueReset();
                } else {
                    if (attribute.ifUndefined) {
                        number.withValueIfUndefined(attribute.doubleValue)
                    } else {
                        number.withValue(attribute.doubleValue)
                    }
                }
            }
            Pigeon.UserProfileAttributeType.STRING -> {
                val string = Attribute.customString(attribute.key)
                if (attribute.reset) {
                    string.withValueReset();
                } else {
                    if (attribute.ifUndefined) {
                        string.withValueIfUndefined(attribute.stringValue)
                    } else {
                        string.withValue(attribute.stringValue)
                    }
                }
            }
            null -> null
        }
    }.forEach { update ->
        update?.let(builder::apply)
    }
    return builder.build()
}

private val genderToNative = mapOf(
    Pigeon.GenderPigeon.MALE to GenderAttribute.Gender.MALE,
    Pigeon.GenderPigeon.FEMALE to GenderAttribute.Gender.FEMALE,
    Pigeon.GenderPigeon.OTHER to GenderAttribute.Gender.OTHER
)

internal fun Pigeon.StackTraceElementPigeon.toNative() = StackTraceItem.Builder()
    .withFileName(fileName)
    .withClassName(className)
    .withMethodName(methodName)
    .withLine(line?.toInt())
    .withColumn(column?.toInt())
    .build();

internal fun Pigeon.ErrorDetailsPigeon.toNative() = if (isNull == true) {
    null
} else {
    toNativeNotNull()
}

internal fun Pigeon.ErrorDetailsPigeon.toNativeNotNull() = PluginErrorDetails.Builder()
    .withExceptionClass(exceptionClass)
    .withMessage(message)
    .withPlatform(PluginErrorDetails.Platform.FLUTTER)
    .withVirtualMachineVersion(dartVersion)
    .withStacktrace(backtrace.map { it.toNative() })
    .build()
