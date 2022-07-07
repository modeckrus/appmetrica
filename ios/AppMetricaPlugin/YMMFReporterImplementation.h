/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFPigeon.h"

@interface YMMFReporterImplementation : NSObject <YMMFReporterPigeon>

- (void)sendEventsBufferApiKey:(NSString *)apiKey error:(FlutterError **)error;
- (void)reportEventApiKey:(NSString *)apiKey eventName:(NSString *)eventName error:(FlutterError **)error;
- (void)reportEventWithJsonApiKey:(NSString *)apiKey eventName:(NSString *)eventName attributesJson:(YMMFStringPigeonWrapper *)attributesJson error:(FlutterError **)error;
- (void)reportErrorApiKey:(NSString *)apiKey error:(YMMFErrorDetailsPigeon *)error message:(YMMFStringPigeonWrapper *)message error:(FlutterError **)flutterError;
- (void)reportErrorWithGroupApiKey:(NSString *)apiKey groupId:(NSString *)groupId error:(YMMFErrorDetailsPigeon *)error message:(YMMFStringPigeonWrapper *)message error:(FlutterError **)flutterError;
- (void)reportUnhandledExceptionApiKey:(NSString *)apiKey error:(YMMFErrorDetailsPigeon *)error error:(FlutterError **)flutterError;
- (void)resumeSessionApiKey:(NSString *)apiKey error:(FlutterError **)error;
- (void)pauseSessionApiKey:(NSString *)apiKey error:(FlutterError **)error;
- (void)setStatisticsSendingApiKey:(NSString *)apiKey enabled:(NSNumber *)enabled error:(FlutterError **)error;
- (void)setUserProfileIDApiKey:(NSString *)apiKey userProfileID:(YMMFStringPigeonWrapper *)userProfileID error:(FlutterError **)error;
- (void)reportUserProfileApiKey:(NSString *)apiKey userProfile:(YMMFUserProfilePigeon *)userProfile error:(FlutterError **)error;
- (void)reportRevenueApiKey:(NSString *)apiKey revenue:(YMMFRevenuePigeon *)revenue error:(FlutterError **)error;
- (void)reportECommerceApiKey:(NSString *)apiKey event:(YMMFECommerceEventPigeon *)event error:(FlutterError **)error;

@end
