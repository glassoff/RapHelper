//
// SpeechKit.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2013 Yandex, LLC. All rights reserved.
//
// Author: Sergey Zimin <szimin@yandex-team.ru>
//

/*!
    @enum _YSKSpeechErrorCode
    @brief Describes errors occurring during recognition and initializer operations.
    @details The error is returned via {@link YSKRecognizerDelegate::onError} and {@link YSKInitializerDelegate::onError} callback functions.
 */
enum _YSKSpeechErrorCode {
    kYSKErrorOk = 0,                /*!< @const kYSKErrorOk  No error */
    kYSKErrorAPIKey,                /*!< @const kYSKErrorAPIKey  API Key error */
    kYSKErrorRecording,             /*!< @const kYSKErrorRecording  Audio recording error */
    kYSKErrorPlaying,               /*!< @const kYSKErrorPlaying  Audio playing error */
    kYSKErrorRecordingPermissions,  /*!< @const kYSKErrorRecordingPermissions  The app does not have permission to use michrophone */
    kYSKErrorAudioInterrupted,      /*!< @const kYSKErrorAudioInterrupted  Audio was interrupted */
    kYSKErrorEncoding,              /*!< @const kYSKErrorEncoding  Encoding error */
    kYSKErrorNetwork,               /*!< @const kYSKErrorNetwork  Networking communication error */
    kYSKErrorServer,                /*!< @const kYSKErrorServer  Server side error */
    kYSKErrorCancelled,             /*!< @const kYSKErrorCancelled  Operation has been cancelled */
    kYSKErrorNoSpeech,              /*!< @const kYSKErrorNoSpeech  No voice detected */
    kYSKErrorNoTextToSynthesize,    /*!< @const kYSKErrorNoTextToSynthesize No text that can be synthesized */
    kYSKErrorNotAvailable,          /*!< @const kYSKErrorNotAvailable  Service is not available */
    kYSKErrorBusy,                  /*!< @const kYSKErrorBusy  Another operation in progress */
    kYSKErrorUnknown,               /*!< @const kYSKErrorUnknown  Unknown error */
    kYSKErrorLanguageNotSupportedForModel /*!< @const kYSKErrorLanguageNotSupportedForModel Language not supported for give model */
};

/*!
    @var YSKSpeechKitErrorDomain
    @brief Error domain for SpeechKit errors.
 */
extern NSString *const YSKSpeechKitErrorDomain;

/*!
    @interface YSKError
    @brief Auxiliary class to create SpeechKit errors.
 */
@interface YSKError : NSError

/*!
    @brief Creates the NSError object representing the error by its error code.
 */
+(NSError* )errorWithErrorCode:(enum _YSKSpeechErrorCode)code;

@end
