//
//  YBAudioFilePlayer.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioFilePlayer.h"
#import "YBAudioException.h"
#import "YBAudioUnitGraph.h"

@interface YBAudioUnitNode (Internal)
- (id)initWithAUNode:(AUNode)auNode audioUnit:(AudioUnit)auAudioUnit inGraph:(YBAudioUnitGraph *)graph;
@end

@implementation YBAudioFilePlayer {
    AudioFileID _audioFileID;
    ScheduledAudioFileRegion _region;
    AudioStreamBasicDescription _unitASBD;
    AudioStreamBasicDescription _fileASBD;
    Float64 _sampleRateRatio;
    UInt64 _filePacketsCount;
}

/**
    Overriden because kAudioUnitProperty_CurrentPlayTime is the playTime relative to the mStartFrame,
    while it often makes more sense to have the time from the beginning of the file.
    In case the player is stopped (currentPlayTime == -1.) the mStartFrame of the current region is
    reported back, which often makes sense as this is often used as the cue point at which the player is `paused`.
 */
- (AudioTimeStamp)currentPlayTime {
    AudioTimeStamp currentPlayTime;
    UInt32 dataSize = sizeof(currentPlayTime);
    YBAudioThrowIfErr(AudioUnitGetProperty(_auAudioUnit, kAudioUnitProperty_CurrentPlayTime, kAudioUnitScope_Global, 0, &currentPlayTime, &dataSize));
    if (currentPlayTime.mSampleTime == -1.) {
        currentPlayTime.mSampleTime = 0;
    }
    currentPlayTime.mFlags = kAudioTimeStampSampleTimeValid;
    currentPlayTime.mSampleTime += _sampleRateRatio * (Float64)_region.mStartFrame;
    return currentPlayTime;
}

- (void)setFileURL:(NSURL *)fileURL {
    [self setFileURL:fileURL typeHint:0];
}

- (void)setFileURL:(NSURL *)fileURL typeHint:(AudioFileTypeID)typeHint {
    if ([_fileURL isEqual:fileURL]) {
        // Same URL as before, do nothing.
        return;
    }
    
    if (_fileURL) {
        // Release old file:
        AudioFileClose(_audioFileID);
    }
    
    _fileURL = fileURL;
    
    if (_fileURL) {
        YBAudioThrowIfErr(AudioFileOpenURL((__bridge CFURLRef)fileURL, kAudioFileReadPermission, typeHint, &_audioFileID));
        YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFileIDs, kAudioUnitScope_Global, 0, &_audioFileID, sizeof(AudioFileID)));
        
        // Get number of audio packets in the file:
        UInt32 propsize = sizeof(_filePacketsCount);
        YBAudioThrowIfErr(AudioFileGetProperty(_audioFileID, kAudioFilePropertyAudioDataPacketCount, &propsize, &_filePacketsCount));
        
        // Get file's asbd:
        propsize = sizeof(_fileASBD);
        YBAudioThrowIfErr(AudioFileGetProperty(_audioFileID, kAudioFilePropertyDataFormat, &propsize, &_fileASBD));
        
        // Get unit's asbd:
        propsize = sizeof(_fileASBD);
        AudioUnitGetProperty(_auAudioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &_unitASBD, &propsize);
        
        if (_fileASBD.mSampleRate > 0 && _unitASBD.mSampleRate > 0) {
            _sampleRateRatio = _unitASBD.mSampleRate / _fileASBD.mSampleRate;
        } else {
            _sampleRateRatio = 1.;
        }
    }
}

- (void)scheduleEntireFilePrimeAndStartImmediately {
    [self setRegionEntireFile];
    [self primeBuffers];
    [self setStartTimeStampSampleTime:-1.];
}

- (void)resetRegionToEntireFileWithStartFrame:(SInt64)startFrame {
    _region.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
    _region.mTimeStamp.mSampleTime = 0; /* Relative to graph's time line */
    _region.mAudioFile = _audioFileID;
    _region.mLoopCount = 0;
    _region.mStartFrame = startFrame;
    _region.mFramesToPlay = (_filePacketsCount * _fileASBD.mFramesPerPacket) - startFrame;
}

- (void)rescheduleEntireFileBeginningAtPlaybackTime:(AudioTimeStamp)timestamp {
    [self unschedule];
    NSAssert((timestamp.mFlags & kAudioTimeStampSampleTimeValid), nil);
    [self resetRegionToEntireFileWithStartFrame:timestamp.mSampleTime / _sampleRateRatio];
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &_region, sizeof(_region)));
    [self primeBuffers];
}

- (void)rescheduleEntireFileBeginningAtCurrentPlaybackTime {
    [self rescheduleEntireFileBeginningAtPlaybackTime:self.currentPlayTime];
}

- (void)setRegionEntireFile {
    [self resetRegionToEntireFileWithStartFrame:0];
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &_region, sizeof(_region)));
}

- (void)setRegion:(ScheduledAudioFileRegion*)region {
    if (region != &_region) {
        memcpy(&_region, region, sizeof(_region));
    }
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &_region, sizeof(_region)));
}

- (ScheduledAudioFileRegion*)region {
    return &_region;
}

- (void)primeBuffers {
    UInt32 defaultVal = 0;
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFilePrime, kAudioUnitScope_Global, 0, &defaultVal, sizeof(defaultVal)));
}

- (void)primeBuffersWithFrames:(UInt32)numberOfFrames {
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFilePrime, kAudioUnitScope_Global, 0, &numberOfFrames, sizeof(numberOfFrames)));
}

- (id)initWithAUNode:(AUNode)auNode audioUnit:(AudioUnit)auAudioUnit inGraph:(YBAudioUnitGraph *)graph {
    self = [super initWithAUNode:auNode audioUnit:auAudioUnit inGraph:graph];
    if (self) {
        _sampleRateRatio = 1.;
    }
    return self;
}

- (void)dealloc {
    [self setFileURL:nil typeHint:0];
}

@synthesize fileURL = _fileURL;
@end
