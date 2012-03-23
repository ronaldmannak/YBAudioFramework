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
}

@synthesize fileURL = _fileURL;

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
    }
}

- (void)scheduleEntireFilePrimeAndStartImmediately {
    [self setRegionEntireFile];
    [self primeBuffers];
    [self setStartTimeStampSampleTime:-1.];
}

- (void)unschedule {
    [self reset];
}

- (void)setRegionEntireFile {
    // Get number of audio packets in the file:
    UInt64 nPackets = 0;
    UInt32 propsize = sizeof(UInt64);
    YBAudioThrowIfErr(AudioFileGetProperty(_audioFileID, kAudioFilePropertyAudioDataPacketCount, &propsize, &nPackets));
    
    // Get file's asbd:
    AudioStreamBasicDescription fileASBD = {0};
    propsize = sizeof(fileASBD);
    YBAudioThrowIfErr(AudioFileGetProperty(_audioFileID, kAudioFilePropertyDataFormat, &propsize, &fileASBD));
    
    // Tell the file player AU to play the entire file and with which point in the graph's time it should start (at time 0)
    // This makes sure the players start at the same time and stay perfectly sync.
    _region.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
    _region.mTimeStamp.mSampleTime = 0;
    _region.mAudioFile = _audioFileID;
    _region.mLoopCount = 0;
    _region.mStartFrame = 0;
    _region.mFramesToPlay = nPackets * fileASBD.mFramesPerPacket;
    
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &_region, sizeof(_region)));
}

- (void)setRegion:(ScheduledAudioFileRegion*)region {
    memcpy(&_region, region, sizeof(_region));
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
        
    }
    return self;
}

- (void)dealloc {
    [self setFileURL:nil typeHint:0];
}

@end
