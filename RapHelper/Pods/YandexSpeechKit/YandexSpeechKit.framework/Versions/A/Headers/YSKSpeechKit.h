//
// SpeechKit.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2013 Yandex, LLC. All rights reserved.
//
// Author: Sergey Zimin <szimin@yandex-team.ru>
//

#import <Foundation/Foundation.h>

@protocol YSKLocationProvider;
@protocol YSKEventLogger;
@class YSKEventLoggerImpl;

/*!
    @defgroup speechkit_globals_group Global YSKSpeechKit constants
    Different {@link YSKSpeechKit} parameters and possible values for some of them for
    use in {@link YSKSpeechKit::setParameter:withValue:} and {@link YSKSpeechKit::getParameter:}.
 */

/*!
    @brief The parameters names.
    @ingroup speechkit_globals_group
 */
//@{
extern NSString *const YSKSoundFormat;              /**< The sound format. See @ref YSKSoundFormat_values_group for possible values. */
extern NSString *const YSKEncodingQuality;          /**< The encoding quality for selected audio codec (if lossy one is selected). Should be integer value in a range [0; 10]. */
extern NSString *const YSKDisableAntimat;           /**< If {@code "true} the obscene words filter is disabled */
extern NSString *const YSKEnablePunctuation;        /**< If {@code "true"} the ASR server will place punctuation. */
extern NSString *const YSKSilenceBetweenUtterances; /**< The minimal silence between utterances in ms.
                                                     * If the silence duration in speech will be longer it will
                                                     * be treaten as end of the current utterance. In continuous
                                                     * mode recognition session will finish after first
                                                     * end-of-utterance, so this parameter works as maximal silence
                                                     * interval in the speech request. */
//@}






/*!
    @defgroup YSKLogLevel_values_group Possible log levels
    @ingroup speechkit_globals_group
 */
enum {
    YSKLogLevelError = 0,
    YSKLogLevelWarn = 1,
    YSKLogLevelInfo = 2,
    YSKLogLevelDebug = 3
};
typedef int YSKLogLevel;

/*!
    @interface YSKSpeechKit
    @brief Singleton class aimed at setting up and controlling overall SpeechKit operation.
    @details The SpeechKit object shall not be explicitly created or destroyed by the user. Access
    to the object is performed by the sharedInstance method that creates the object when called for
    the first time. The object is destroyed during the user application termination.
 */
@interface YSKSpeechKit : NSObject

/*!
    @brief Returns the SpeechKit version
    @return The SpeechKit version as a string.
 */
+ (NSString *)speechkitVersion;

/*!
    @brief Returns a shared instance of the {@link YSKSpeechKit} class
    @return The shared instance of the {@link YSKSpeechKit} class
 */
+ (instancetype)sharedInstance;

/*!
    @brief Configures and sets up the SpeechKit framework.

    @details This method should be called before any actual functionality (such as creating
    a {@link YSKRecognizer}).

    @param apiKey the key provided by Yandex. Refer to \ref apikeys for the instructions.
    @note The actual API Key validation is performed during backend operations (such as
    initialization) and may result in the {@link _YSKSpeechErrorCode::kYSKErrorAPIKey} error.
 */
- (void)configureWithAPIKey:(NSString *)apiKey;

/*!
 @brief Configures and sets up the SpeechKit framework.

 @details This method should be called before any actual functionality (such as creating a
 {@link YSKRecognizer}).

 @param apiKey the key provided by Yandex. Refer to \ref apikeys for the instructions.
 @note The actual API Key validation is performed during backend operations (such as
 initialization) and may result in the {@link _YSKSpeechErrorCode::kYSKErrorAPIKey} error.

 @param locationProvider the object that used by SpeechKit to get user's location.
 @note If SpeechKit was configured using {@link YSKSpeechKit::configureWithAPIKey:} it will use
 its internal location provider.
*/
- (void)configureWithAPIKey:(NSString *)apiKey andLocationProvider:(id<YSKLocationProvider>)locationProvider;

/*!
    @brief Set the proprietary SpeechKit parameter.

    @details See the @ref speechkit_globals_group for possible parameters.

    @param name the name of the parameter.
    @param value the value of the parameter.
 */
- (void)setParameter:(NSString *)name withValue:(NSString *)value;

/*!
    @brief Gets the proprietary SpeechKit parameter.

    @details See the @ref speechkit_globals_group for possible parameters.

    @param name the name of the parameter.
    @return The value of the parameter.
 */
- (NSString *)getParameterValue:(NSString *)name;

/*!
    @brief Returns the SpeechKit API Key.
    @return The SpeechKit API Key.
 */
- (NSString *)getAPIKey;

/*!
 @brief Returns the list of supported languages for a given model.
 @param model The name of the model.
 */
- (NSArray *)getSupportedLanguages:(NSString *)model;

/*!
    @brief Returns the UUID used for requests.
    @return The UUID.
 */
- (NSString *)getUuid;

/*!
    @brief Sets log level
 */
- (void)setLogLevel:(YSKLogLevel)logLevel;

@end
