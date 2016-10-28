//
// YSKPhraseSpotter.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2014, 2015 Yandex, LLC. All rights reserved.
//
// Author: Alexander Panin <agpanin@yandex-team.ru>
// Author: Yuriy Shirokov <yashrk@yandex-team.ru>
//

#import <Foundation/Foundation.h>

@class YSKPhraseSpotterModel;
@class YSKEmbeddedRecognizerModel;

@protocol YSKPhraseSpotterDelegate;

/*!
    @interface YSKPhraseSpotter
    @brief The interface to a PhraseSpotter.
    @details
 */
@interface YSKPhraseSpotter : NSObject

/*!
    @brief Sets the model for the phrase spotter
 */
+ (NSError*)setModel:(YSKPhraseSpotterModel*)model;

/*!
    @brief Starts the phrase spotting process.
 */
+ (NSError*)start;

/*!
    @brief Sropps the phrase spotting process.
 */
+ (NSError*)stop;

/*!
    @brief Returns the phrase spotter's state..
 */
+ (BOOL)isRunning;

/*!
    @brief Sets the delegate for the phrase spotter events handling
    @details The delegate will receive notifications when the spotting process starts and finishes,
    when a phrase is spotted, and when an error occurs.

    @param delegate The delegate object for the phrase spotter callbacks.
 */
+ (void)setDelegate:(id<YSKPhraseSpotterDelegate>)delegate;

@end
