//
// YSKSpeechRecognitionViewController.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2015 Yandex, LLC. All rights reserved.
//
// Created by Dmitry Egorov on 26/10/14.
//

#import <UIKit/UIKit.h>

@protocol YSKSpeechRecognitionViewControllerDelegate;

/*!
 @interface YSKSpeechRecognitionViewController
 @brief View Controller for simplified speech recognition functionality integration.
 @details This class is intended to simplify integration of the speech recognition functionality into applications. In a nutshell, this class returns the single string uttered by the user and handles all the issues.

 {@link YSKSpeechRecognitionViewController} manages the entire recognition process including the user interface for recognition, managing underlying {@link YSKRecognizer} and {@link YSKInitializer} objects, and so on.

 {@link YSKSpeechRecognitionViewController} notifies via the {@link YSKSpeechRecognitionViewControllerDelegate} interface about important outcomes of the recognition process.

 @note SpeechKit shall be configured via {@link YSKSpeechKit::configureWithAPIKey:} before creating any recognizer.

 @note {@link YSKSpeechRecognitionViewController} initializes and holds several mutual resources, so two instances of the Recognizer may not co-exist.
 */
@interface YSKSpeechRecognitionViewController : UIViewController

/*!
 @property delegate
 @brief The delegate that will be notified about the recognition flow.
 @details The delegate will receive notification when the initialization starts and finishs successfully or with an error.
 */
@property(nonatomic, weak) id<YSKSpeechRecognitionViewControllerDelegate> delegate;

/*!
 @property partialResultsDisplayEnabled
 @brief Partial results will be displayed if set to `YES`.
 */
@property (assign, nonatomic) BOOL partialResultsDisplayEnabled;

/*!
 @property resultsListDisplayEnabled
 @brief The results list will be displayed if `YES`.
 */
@property (assign, nonatomic) BOOL resultsListDisplayEnabled;

/*!
 @brief Create the YSKSpeechRecognitionViewController object.
 @details Call the {@link start} method to start the recognition process.
 @param language the language for the recognition.
 @param model the model for the recognition.
 @return The created {@link YSKSpeechRecognitionViewController} object to perform the recognition with specified parameters.
 */
- (instancetype)initWithLanguage:(NSString *)language model:(NSString *)model;

- (instancetype)initWithModel:(NSString *)model;

/*!
 @brief Checks whether the recognition is currently available.
 @note If the initialization has not been completed, the function always returns YES.
 */
+ (BOOL)isRecognitionAvailable;

/*!
 @brief Cancels the recognition request.
 @details The method cancels the recognition request at any stage of the operation. The audio recording stops and network communication breaks if needed.
 @note The function cancels the request asynchronously. This means that the recognition is not cancelled immediately after invoking this function and it still might invoke callbacks.
 @note The method does not destroy the object. The recognizer will be destroied automatically when either {@link YSKSpeechRecognitionViewControllerDelegate::speechRecognitionViewController:didFailWithError:} or {@link YSKSpeechRecognitionViewControllerDelegate::speechRecognitionViewController:didFinishWithResult:} method is invoked.
 */
- (void)cancel;

@end
