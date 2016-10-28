//
// YSKPhraseSpotterDelegate.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2014 Yandex, LLC. All rights reserved.
//
// Author: Alexander Panin <agpanin@yandex-team.ru>
//
//

#import <Foundation/Foundation.h>

/*!
    @protocol YSKPhraseSpotterDelegate
    @brief The interface defines delegate interface invoked by {@link YSKPhraseSpotter}.
    @details
 */
@protocol YSKPhraseSpotterDelegate<NSObject>

@optional

/*!
    @brief Called when the phrase spotter starts listening audio.
 */
- (void)phraseSpotterDidStarted;


/*!
    @brief Called when the phrase spotter stops listening audio.
 */
- (void)phraseSpotterDidStopped;


/*!
    @brief Called when the phrase spotter spotts the phrase.

    @note the {@link PhraseSpotter} doesn't release audio resources during this call. If you are going to use audio
    you should stop the {@link PhraseSpotter} sending the {@link PhraseSpotter::stop} message to it.
    @note You should avoid to block in this method, because {@link PhraseSpotter} calls it in it's main thread.

    @param phrase the phrase
    @param phraseIndex the index of the phrase
 */
- (void)phraseSpotterDidSpotPhrase:(NSString *)phrase withIndex:(int)phraseIndex;

/*!
    @brief Called when the spotting process failed with an error.

    @param error the error occured.
 */
- (void)phraseSpotterDidFailWithError:(NSError *)error;

@end
