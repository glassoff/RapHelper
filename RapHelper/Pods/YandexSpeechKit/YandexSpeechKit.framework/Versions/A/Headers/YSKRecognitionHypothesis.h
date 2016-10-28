//
// YSKRecognitionHypothesis.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2013 Yandex, LLC. All rights reserved.
//
// Author: Sergey Zimin <szimin@yandex-team.ru>
//

#import <Foundation/Foundation.h>

@class YSKRecognitionWord;

@interface YSKRecognitionHypothesis : NSObject

@property (nonatomic, assign, readonly) float confidence;

@property (nonatomic, copy, readonly) NSString *normalized;

@property (nonatomic, copy, readonly) NSArray *words;

- (instancetype)initWithWords:(NSArray*)words normalizedText:(NSString *)normalized confidence:(float)confidence;

- (NSString *)description;

@end
