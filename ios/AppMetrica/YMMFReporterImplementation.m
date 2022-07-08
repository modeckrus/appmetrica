/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "YMMFReporterImplementation.h"
#import "YMMFRevenueInfoConverter.h"
#import "YMMFECommerceConverter.h"
#import "YMMFUserProfileConverter.h"
#import "YMMFPluginErrorDetailsConverter.h"

@implementation YMMFReporterImplementation

- (void)sendEventsBufferApiKey:(NSString *)apiKey error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] sendEventsBuffer];
}

- (void)reportEventApiKey:(NSString *)apiKey eventName:(NSString *)eventName error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportEvent:eventName onFailure:nil];
}

- (void)reportEventWithJsonApiKey:(NSString *)apiKey
                        eventName:(NSString *)eventName
                   attributesJson:(YMMFStringPigeonWrapper *)attributesJson
                            error:(FlutterError **)error
{
    NSDictionary *attributes = nil;
    NSError *jsonValidationError = nil;
    if (attributesJson.stringPigeon != nil) {
        attributes = [NSJSONSerialization JSONObjectWithData:[attributesJson.stringPigeon dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:kNilOptions
                                                       error:&jsonValidationError];
    }
    if (jsonValidationError == nil && (attributes == nil || [attributes isKindOfClass:[NSDictionary class]])) {
        [[YMMYandexMetrica reporterForApiKey:apiKey] reportEvent:eventName
                                                      parameters:attributes
                                                       onFailure:nil];
    }
    else {
        NSLog(@"Invalid attributesJson to report to AppMetrica %@", attributesJson);
    }
}

- (void)reportErrorApiKey:(NSString *)apiKey
                    error:(YMMFErrorDetailsPigeon *)error
                  message:(YMMFStringPigeonWrapper *)message
                    error:(FlutterError **)flutterError
{
    [[[YMMYandexMetrica reporterForApiKey:apiKey] getPluginExtension] reportError:[YMMFPluginErrorDetailsConverter convert:error]
                                                                          message:message.stringPigeon
                                                                        onFailure:nil];
}

- (void)reportErrorWithGroupApiKey:(NSString *)apiKey
                           groupId:(NSString *)groupId
                             error:(YMMFErrorDetailsPigeon *)error
                           message:(YMMFStringPigeonWrapper *)message
                             error:(FlutterError **)flutterError
{
    [[[YMMYandexMetrica reporterForApiKey:apiKey] getPluginExtension] reportErrorWithIdentifier:groupId
                                                                                        message:message.stringPigeon
                                                                                        details:[YMMFPluginErrorDetailsConverter convert:error]
                                                                                      onFailure:nil];
}

- (void)reportUnhandledExceptionApiKey:(NSString *)apiKey
                                 error:(YMMFErrorDetailsPigeon *)error
                                 error:(FlutterError **)flutterError
{
    [[[YMMYandexMetrica reporterForApiKey:apiKey] getPluginExtension] reportUnhandledException:[YMMFPluginErrorDetailsConverter convert:error]
                                                                                     onFailure:nil];
}

- (void)resumeSessionApiKey:(NSString *)apiKey error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] resumeSession];
}

- (void)pauseSessionApiKey:(NSString *)apiKey error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] pauseSession];
}

- (void)setStatisticsSendingApiKey:(NSString *)apiKey enabled:(NSNumber *)enabled error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] setStatisticsSending:enabled.boolValue];
}

- (void)setUserProfileIDApiKey:(NSString *)apiKey
                 userProfileID:(YMMFStringPigeonWrapper *)userProfileID
                         error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] setUserProfileID:userProfileID.stringPigeon];
}

- (void)reportUserProfileApiKey:(NSString *)apiKey
                    userProfile:(YMMFUserProfilePigeon *)userProfile
                          error:(FlutterError **)error {
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportUserProfile:[YMMFUserProfileConverter convert:userProfile] onFailure:nil];
}

- (void)reportRevenueApiKey:(NSString *)apiKey revenue:(YMMFRevenuePigeon *)revenue error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportRevenue:[YMMFRevenueInfoConverter convert:revenue] onFailure:nil];
}

- (void)reportECommerceApiKey:(NSString *)apiKey event:(YMMFECommerceEventPigeon *)event error:(FlutterError **)error
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportECommerce:[YMMFECommerceConverter convert:event] onFailure:nil];
}

@end
