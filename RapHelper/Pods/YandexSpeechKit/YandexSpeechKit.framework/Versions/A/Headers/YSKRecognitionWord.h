//
// YSKRecognitionWord.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2014 Yandex, LLC. All rights reserved.
//
// Author: Kirichenko Vladimir <vvkiri@yandex-team.ru>
//

#import <Foundation/Foundation.h>

@interface YSKRecognitionWord: NSObject

@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, assign, readonly) float confidence;

- (instancetype)initWithText:(NSString *)text confidence:(float)confidence;

- (NSString *)description;

@end

