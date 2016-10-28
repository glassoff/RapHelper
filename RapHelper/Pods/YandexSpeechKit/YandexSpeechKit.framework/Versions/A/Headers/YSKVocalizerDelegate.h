//
//  YSKVocalizerDelegate.h
//  SpeechKit
//
//  Created by Georgy Bronnikov on 07.05.13.
//  Copyright (c) 2013 Yandex LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSKVocalizer;

@protocol YSKVocalizerDelegate <NSObject>

@optional

- (void)vocalizerDidBeginSynthesis:(YSKVocalizer *)vocalizer;
- (void)vocalizer:(YSKVocalizer *)vocalizer didFinishSynthesisWithResult:(NSData *)result markerIds:(NSArray *)markerIds markerMsecs:(NSArray *)markerMsecs;
- (void)vocalizerDidStartPlaying:(YSKVocalizer *)vocalizer;
- (void)vocalizerDidFinishPlaying:(YSKVocalizer *)vocalizer;
- (void)vocalizer:(YSKVocalizer *)vocalizer didFailWithError:(NSError*)error;

@end
