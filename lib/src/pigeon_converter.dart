/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'dart:convert';
import 'dart:io';

import 'package:appmetrica/src/pigeon.dart';
import 'package:stack_trace/stack_trace.dart';

import 'appmetrica_config.dart';
import 'error_description.dart';
import 'location.dart';
import 'revenue.dart';

RevenuePigeon convertRevenue(Revenue revenue) => RevenuePigeon()
  ..price = revenue.price.toString()
  ..currency = revenue.currency
  ..productId = revenue.productId
  ..quantity = revenue.quantity
  ..payload = revenue.payload
  ..transactionId = revenue.transactionId
  ..receipt = revenue.receipt == null
      ? (ReceiptPigeon()..isNull = true)
      : (ReceiptPigeon()
        ..data = revenue.receipt!.data
        ..signature = revenue.receipt!.signature);

StringPigeonWrapper convertString(String? value) => StringPigeonWrapper()..stringPigeon = value;

StringPigeonWrapper convertMapToJson(Map<String, Object>? attributes) =>
    StringPigeonWrapper()..stringPigeon=jsonEncode(attributes);

List<StackTraceElementPigeon> convertErrorStackTrace(StackTrace stack) {
  final backtrace = Trace.from(stack).frames.map((element) {
    final firstDot = element.member?.indexOf("\.") ?? -1;
    return StackTraceElementPigeon()
      ..className = firstDot >= 0 ? element.member?.substring(0, firstDot) : null
      ..methodName = element.member?.substring(firstDot + 1)
      ..fileName = element.library
      ..line = element.line
      ..column = element.column;
  });
  return backtrace.toList(growable: false);
}

extension AppMetricaErrorDescriptionSubstitutor on AppMetricaErrorDescription? {

  AppMetricaErrorDescription tryToAddCurrentTrace() => _convert(this);

  AppMetricaErrorDescription _convert(AppMetricaErrorDescription? description) {
    if (description == null) {
      return AppMetricaErrorDescription.fromCurrentStackTrace();
    } else {
      return description;
    }
  }

}

extension AppMetricaErrorDescriptionSerializer on AppMetricaErrorDescription? {
  ErrorDetailsPigeon toPigeon() => _convert(this);

  ErrorDetailsPigeon _convert(AppMetricaErrorDescription? description) => description == null
      ? (ErrorDetailsPigeon()..isNull = true)
      : convertErrorDetails(description.type, description.message, description.stackTrace);
}

ErrorDetailsPigeon convertErrorDetails(String? clazz, String? msg, StackTrace? stack) => ErrorDetailsPigeon()
  ..exceptionClass = clazz
  ..message = msg
  ..dartVersion = Platform.version
  ..backtrace = stack != null ? convertErrorStackTrace(stack) : [];

extension LocationConverter on Location? {
  LocationPigeon toPigeon() => _wrap(this);

  LocationPigeon _wrap(Location? location) => location == null
      ? (LocationPigeon()..isNull = true)
      : (LocationPigeon()
        ..latitude = location.latitude
        ..longitude = location.longitude
        ..provider = location.provider
        ..altitude = location.altitude
        ..accuracy = location.accuracy
        ..course = location.course
        ..speed = location.speed
        ..timestamp = location.timestamp);
}

extension ConfigConverter on AppMetricaConfig {
  AppMetricaConfigPigeon toPigeon() => AppMetricaConfigPigeon()
    ..apiKey = apiKey
    ..appVersion = appVersion
    ..crashReporting = crashReporting
    ..firstActivationAsUpdate = firstActivationAsUpdate
    ..location = location.toPigeon()
    ..locationTracking = locationTracking
    ..logs = logs
    ..sessionTimeout = sessionTimeout
    ..statisticsSending = statisticsSending
    ..preloadInfo = preloadInfo == null
        ? (PreloadInfoPigeon()..isNull = true)
        : (PreloadInfoPigeon()
          ..trackingId = preloadInfo?.trackingId
          ..additionalInfo = preloadInfo?.additionalInfo)
    ..maxReportsInDatabaseCount = maxReportsInDatabaseCount
    ..nativeCrashReporting = nativeCrashReporting
    ..sessionsAutoTracking = sessionsAutoTracking
    ..errorEnvironment = errorEnvironment
    ..userProfileID = userProfileID
    ..revenueAutoTracking = revenueAutoTracking;
}
