//
//  YSKVocalizer.h
//  SpeechKit
//
//  Created by Georgy Bronnikov on 07.05.13.
//  Copyright (c) 2013 Yandex LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Male voice
extern NSString *const YSKVocalizerVoiceErmil;
/// Male voice
extern NSString *const YSKVocalizerVoiceZahar;
/// Female voice, default
extern NSString *const YSKVocalizerVoiceJane;
/// Female default voice
extern NSString *const YSKVocalizerVoiceAlyss;
/// Female default voice
extern NSString *const YSKVocalizerVoiceOmazh;

extern NSString *const YSKVocalizerLanguageEnglish;
extern NSString *const YSKVocalizerLanguageTurkish;
extern NSString *const YSKVocalizerLanguageUkrainian;
extern NSString *const YSKVocalizerLanguageRussian;


@protocol YSKVocalizerDelegate;

@interface YSKVocalizer : NSObject

@property (nonatomic, assign) id<YSKVocalizerDelegate> delegate;
@property (retain, nonatomic) NSString * text;

- (id)initWithText:(NSString *)text language:(NSString*)language;
- (id)initWithText:(NSString *)text language:(NSString*)language autoPlay:(BOOL) autoPlay;
- (id)initWithText:(NSString *)text language:(NSString*)language autoPlay:(BOOL) autoPlay voice:(NSString*)voice;

/// Starts playing audio
- (void)start;

/// Cancels playing generated audio
- (void)cancel;

/// Plays received sound (if autoPlay is false)
- (void)play;

@end
