//
//  YBScheduledSoundPlayer.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBScheduledSoundPlayer.h"
#import "YBAudioException.h"

@implementation YBScheduledSoundPlayer

- (AudioTimeStamp)currentPlayTime {
    AudioTimeStamp currentPlayTime;
    UInt32 dataSize = sizeof(currentPlayTime);
    YBAudioThrowIfErr(AudioUnitGetProperty(_auAudioUnit, kAudioUnitProperty_CurrentPlayTime, kAudioUnitScope_Global, 0, &currentPlayTime, &dataSize));
    return currentPlayTime;
}

- (void)setStartTimeStampImmediately {
    [self setStartTimeStampSampleTime:-1.];
}

- (void)setStartTimeStampSampleTime:(Float64)startSampleTime {
    AudioTimeStamp startTime = {0};
    startTime.mFlags = kAudioTimeStampSampleTimeValid;
    startTime.mSampleTime = startSampleTime;
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduleStartTimeStamp, kAudioUnitScope_Global, 0, &startTime, sizeof(startTime)));
}

- (void)setStartTimeStamp:(AudioTimeStamp*)startTime {
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduleStartTimeStamp, kAudioUnitScope_Global, 0, &startTime, sizeof(startTime)));
}

@end
