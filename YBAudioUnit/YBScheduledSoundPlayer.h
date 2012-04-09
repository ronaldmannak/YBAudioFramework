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
    Read-only property containing the player's current playback time,
    offset from its start time.
 */
@property (nonatomic, readonly) AudioTimeStamp currentPlayTime;

/**
    Read-only property indicating whether playback has started.
 */
@property (nonatomic, readonly) BOOL isPlaying;

/**
    Read-only property indicating whether the startTimeStamp has been set,
    i.e. if it is scheduled and possibly playing.
 */
@property (nonatomic, readonly) BOOL hasStartTimeStamp;

/**
    Methods to set the ScheduleStartTimeStamp property.
    @see kAudioUnitProperty_ScheduleStartTimeStamp
 */
- (void)setStartTimeStampImmediately;
- (void)setStartTimeStampSampleTime:(Float64)startSampleTime;
- (void)setStartTimeStamp:(AudioTimeStamp*)startTime;

/**
    Convenience method to unschedule previously scheduled regions.
    If the player unit has already started playback, it will stop.
 */
- (void)unschedule;

@end
