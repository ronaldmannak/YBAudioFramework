//
//  YBScheduledSoundPlayer.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioUnitNode.h"

/**
    Convenience wrapper for AUScheduledSoundPlayer, which is the generator
    unit that can schedule the playback of arbitrary slices of audio.
    It's is not implemented completely (todo?) and serves merely as the
    super class for YBAudioFilePlayer.
 */
@interface YBScheduledSoundPlayer : YBAudioUnitNode

/**
    Read-only property containing the player's current playback time.
 */
@property (nonatomic, readonly) AudioTimeStamp currentPlayTime;

/**
    Methods to set the ScheduleStartTimeStamp property.
    @see kAudioUnitProperty_ScheduleStartTimeStamp
 */
- (void)setStartTimeStampImmediately;
- (void)setStartTimeStampSampleTime:(Float64)startSampleTime;
- (void)setStartTimeStamp:(AudioTimeStamp*)startTime;

@end
