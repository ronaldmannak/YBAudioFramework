//
//  YBVarispeedConverter.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 4/9/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBVarispeedConverter.h"
#import "YBAudioUtils.h"

@implementation YBVarispeedConverter

@dynamic playbackRate;
@dynamic playbackCents;

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
    YBAudioUnitResolveAccessorPair(playbackRate, PlaybackRate, kVarispeedParam_PlaybackRate, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(playbackCents, PlaybackCents, kVarispeedParam_PlaybackCents, kAudioUnitScope_Global, 0);
    return [super resolveInstanceMethod:aSEL];
}

@end
