/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'package:appmetrica/src/ecommerce_event.dart';

import '../error_description.dart';
import '../pigeon.dart';
import '../pigeon_converter.dart';
import '../profile/attribute.dart';
import '../revenue.dart';
import 'reporter.dart';

class ReporterImpl implements Reporter {
  static final _reporterPigeon = ReporterPigeon();

  final String _apiKey;

  ReporterImpl(this._apiKey);

  @override
  Future<void> pauseSession() => _reporterPigeon.pauseSession(_apiKey);

  // @override
  // Future<void> putErrorEnvironmentValue(String key, String? value) =>
  //     _reporterPigeon.putErrorEnvironmentValue(_apiKey, key, convertString(value));

  @override
  Future<void> reportECommerce(ECommerceEvent event) =>
      _reporterPigeon.reportECommerce(_apiKey, convertEcommerce(event));

  @override
  Future<void> reportError({String? message, AppMetricaErrorDescription? errorDescription}) =>
      _reporterPigeon.reportError(_apiKey, errorDescription.tryToAddCurrentTrace().toPigeon(), convertString(message));

  @override
  Future<void> reportErrorWithGroup(String groupId, {AppMetricaErrorDescription? errorDescription, String? message}) =>
      _reporterPigeon.reportErrorWithGroup(_apiKey, groupId, errorDescription.toPigeon(), convertString(message));

  @override
  Future<void> reportEvent(String eventName) => _reporterPigeon.reportEvent(_apiKey, eventName);

  @override
  Future<void> reportEventWithJson(String eventName, String? attributesJson) =>
      _reporterPigeon.reportEventWithJson(_apiKey, eventName, convertString(attributesJson));

  @override
  Future<void> reportEventWithMap(String eventName, Map<String, Object>? attributes) =>
      _reporterPigeon.reportEventWithJson(_apiKey, eventName, convertMapToJson(attributes));

  @override
  Future<void> reportRevenue(Revenue revenue) => _reporterPigeon.reportRevenue(_apiKey, convertRevenue(revenue));

  @override
  Future<void> reportUnhandledException(AppMetricaErrorDescription error) =>
      _reporterPigeon.reportUnhandledException(_apiKey, error.toPigeon());

  @override
  Future<void> resumeSession() => _reporterPigeon.resumeSession(_apiKey);

  @override
  Future<void> sendEventsBuffer() => _reporterPigeon.sendEventsBuffer(_apiKey);

  @override
  Future<void> setStatisticsSending(bool enabled) => _reporterPigeon.setStatisticsSending(_apiKey, enabled);

  @override
  Future<void> setUserProfileID(String? userProfileID) =>
      _reporterPigeon.setUserProfileID(_apiKey, convertString(userProfileID));

  @override
  Future<void> reportUserProfile(UserProfile userProfile) =>
      _reporterPigeon.reportUserProfile(_apiKey, userProfile.toPigeon());

}
