//
// YSKPhraseSpotterModel.h
//
// This file is a part of the Yandex SpeechKit project.
//
// (C) Copyright 2015 Yandex, LLC. All rights reserved.
//
// Author: Yuriy Shirokov <yashrk@yandex-team.ru>
//

#import <Foundation/Foundation.h>

@interface YSKPhraseSpotterModel : NSObject

- (id)initWithConfigDirectory:(NSString *)configDirectory;

- (NSError*)load;

- (NSError*)unload;

- (void)finalize;

@end
