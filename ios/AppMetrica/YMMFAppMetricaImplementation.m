/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <CoreLocation/CoreLocation.h>

#import "YMMFAppMetricaImplementation.h"
#import "YMMFECommerceConverter.h"
#import "YMMFLocationConverter.h"
#import "YMMFRevenueInfoConverter.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "YMMFUserProfileConverter.h"
#import "YMMFAppMetricaConfigConverter.h"
#import "YMMFPluginErrorDetailsConverter.h"
#import "YMMFAppMetricaActivator.h"

@implementation YMMFAppMetricaImplementation

- (void)activateConfig:(YMMFAppMetricaConfigPigeon *)pigeon error:(FlutterError **)flutterError
{
    [[YMMFAppMetricaActivator sharedInstance] activateWithConfig:[YMMFAppMetricaConfigConverter convert:pigeon]];
}

- (void)activateReporterConfig:(YMMFReporterConfigPigeon *)pigeon error:(FlutterError **)flutterError
{
    YMMMutableReporterConfiguration *configuration = [[YMMMutableReporterConfiguration alloc] initWithApiKey:pigeon.apiKey];
    if (pigeon.sessionTimeout != nil) {
        configuration.sessionTimeout = pigeon.sessionTimeout.unsignedLongValue;
    }
    if (pigeon.statisticsSending != nil) {
        configuration.statisticsSending = pigeon.statisticsSending.boolValue;
    }
    if (pigeon.maxReportsInDatabaseCount != nil) {
        configuration.maxReportsInDatabaseCount = pigeon.maxReportsInDatabaseCount.unsignedLongValue;
    }
    if (pigeon.userProfileID != nil) {
        configuration.userProfileID = pigeon.userProfileID;
    }
    if (pigeon.logs != nil) {
        configuration.logs = pigeon.logs.boolValue;
    }
    [YMMYandexMetrica activateReporterWithConfiguration:configuration];
}

- (void)touchReporterApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reporterForApiKey:apiKey];
}

- (NSNumber *)getLibraryApiLevelWithError:(FlutterError **)flutterError
{
    return nil;
}

- (NSString *)getLibraryVersionWithError:(FlutterError **)flutterError
{
    return [YMMYandexMetrica libraryVersion];
}

- (void)resumeSessionWithError:(FlutterError **)flutterError
{
    [YMMYandexMetrica resumeSession];
}

- (void)pauseSessionWithError:(FlutterError **)flutterError
{
    [YMMYandexMetrica pauseSession];
}

- (void)reportAppOpenDeeplink:(YMMFStringPigeonWrapper *)deeplink error:(FlutterError **)flutterError
{
    [YMMYandexMetrica handleOpenURL:[NSURL URLWithString:deeplink.stringPigeon]];
}

- (void)reportErrorError:(YMMFErrorDetailsPigeon *)error message:(YMMFStringPigeonWrapper *)message error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica getPluginExtension] reportError:[YMMFPluginErrorDetailsConverter convert:error]
                                               message:message.stringPigeon
                                             onFailure:nil];
}

- (void)reportErrorWithGroupGroupId:(NSString *)groupId error:(YMMFErrorDetailsPigeon *)error message:(YMMFStringPigeonWrapper *)message error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica getPluginExtension] reportErrorWithIdentifier:groupId
                                                             message:message.stringPigeon
                                                             details:[YMMFPluginErrorDetailsConverter convert:error]
                                                           onFailure:nil];
}

- (void)reportUnhandledExceptionError:(YMMFErrorDetailsPigeon *)error error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica getPluginExtension] reportUnhandledException:[YMMFPluginErrorDetailsConverter convert:error]
                                                          onFailure:nil];
}

- (void)reportEventWithJsonEventName:(NSString *)eventName attributesJson:(YMMFStringPigeonWrapper *)attributesJson error:(FlutterError **)flutterError
{
    NSDictionary *attributes = nil;
    NSError *error = nil;
    if (attributesJson.stringPigeon != nil) {
        attributes = [NSJSONSerialization JSONObjectWithData:[attributesJson.stringPigeon dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:kNilOptions
                                                       error:&error];
    }
    if (error == nil && (attributes == nil || [attributes isKindOfClass:[NSDictionary class]])) {
        [YMMYandexMetrica reportEvent:eventName
                           parameters:attributes
                            onFailure:nil];
    }
    else {
        NSLog(@"Invalid attributesJson to report to AppMetrica %@", attributesJson);
    }
}

- (void)reportEventEventName:(NSString *)eventName error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportEvent:eventName
                        onFailure:nil];
}

- (void)reportReferralUrlReferralUrl:(NSString *)referralUrl error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportReferralUrl:[NSURL URLWithString:referralUrl]];
}

- (void)requestDeferredDeeplinkWithCompletion:(void(^)(YMMFAppMetricaDeferredDeeplinkPigeon *, FlutterError *))flutterCompletion
{
    YMMFAppMetricaDeferredDeeplinkErrorPigeon *error = [[YMMFAppMetricaDeferredDeeplinkErrorPigeon alloc] init];
    error.reason = YMMFAppMetricaDeferredDeeplinkReasonPigeonUNKNOWN;
    YMMFAppMetricaDeferredDeeplinkPigeon *pigeon = [[YMMFAppMetricaDeferredDeeplinkPigeon alloc] init];
    pigeon.error = error;
    flutterCompletion(pigeon, nil);
}

- (void)requestDeferredDeeplinkParametersWithCompletion:(void(^)(YMMFAppMetricaDeferredDeeplinkParametersPigeon *, FlutterError *))flutterCompletion
{
    YMMFAppMetricaDeferredDeeplinkErrorPigeon *error = [[YMMFAppMetricaDeferredDeeplinkErrorPigeon alloc] init];
    error.reason = YMMFAppMetricaDeferredDeeplinkReasonPigeonUNKNOWN;
    YMMFAppMetricaDeferredDeeplinkParametersPigeon *pigeon = [[YMMFAppMetricaDeferredDeeplinkParametersPigeon alloc] init];
    pigeon.error = error;
    flutterCompletion(pigeon, nil);
}

- (void)requestAppMetricaDeviceIDWithCompletion:(void(^)(YMMFAppMetricaDeviceIdPigeon *, FlutterError *))flutterCompletion
{
    [YMMYandexMetrica requestAppMetricaDeviceIDWithCompletionQueue:nil
                                                   completionBlock:^(NSString *appMetricaDeviceID, NSError *error) {
        YMMFAppMetricaDeviceIdPigeon *result = [[YMMFAppMetricaDeviceIdPigeon alloc] init];
        if (error == nil) {
            result.deviceId = appMetricaDeviceID;
            result.errorReason = YMMFAppMetricaDeviceIdReasonPigeonNO_ERROR;
        } else {
            result.deviceId = nil;
            if ([error.domain isEqualToString:NSURLErrorDomain]) {
                result.errorReason = YMMFAppMetricaDeviceIdReasonPigeonNETWORK;
            }
            else {
                result.errorReason = YMMFAppMetricaDeviceIdReasonPigeonUNKNOWN;
            }
        }
        flutterCompletion(result, nil);
    }];
}

- (void)sendEventsBufferWithError:(FlutterError **)flutterError
{
    [YMMYandexMetrica sendEventsBuffer];
}

- (void)setLocationLocation:(YMMFLocationPigeon *)location error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setLocation:[YMMFLocationConverter convert:location]];
}

- (void)setLocationTrackingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setLocationTracking:enabled.boolValue];
}

- (void)setStatisticsSendingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setStatisticsSending:enabled.boolValue];
}

- (void)setUserProfileIDUserProfileID:(YMMFStringPigeonWrapper *)userProfileID error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setUserProfileID:userProfileID.stringPigeon];
}

- (void)reportUserProfileUserProfile:(YMMFUserProfilePigeon *)userProfile error:(FlutterError **)error
{
    [YMMYandexMetrica reportUserProfile:[YMMFUserProfileConverter convert:userProfile] onFailure:nil];
}

- (void)putErrorEnvironmentValueKey:(NSString *)key value:(YMMFStringPigeonWrapper *)value error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setErrorEnvironmentValue:value.stringPigeon
                                        forKey:key];
}

- (void)reportRevenueRevenue:(YMMFRevenuePigeon *)revenue error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportRevenue:[YMMFRevenueInfoConverter convert:revenue]
                          onFailure:nil];
}

- (void)reportECommerceEvent:(YMMFECommerceEventPigeon *)event error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportECommerce:[YMMFECommerceConverter convert:event]
                            onFailure:nil];
}

- (void)handlePluginInitFinishedWithError:(FlutterError **)error
{
    [[YMMYandexMetrica getPluginExtension] handlePluginInitFinished];
}

@end
