//
// YSKRecognition.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2013 Yandex, LLC. All rights reserved.
//
// Author: Sergey Zimin <szimin@yandex-team.ru>
//

#import <Foundation/Foundation.h>

@class YSKRecognitionHypothesis;

@interface YSKRecognition : NSObject

@property (nonatomic, copy, readonly) NSArray *hypotheses;

@property (nonatomic, retain, readonly) NSString *bestResultText;

- (instancetype)initWithHypotheses:(NSArray *)hypotheses;

- (NSString *)description;

@end
