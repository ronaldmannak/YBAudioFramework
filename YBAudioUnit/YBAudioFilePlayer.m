//
//  YBAudioFilePlayer.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioFilePlayer.h"
#import "YBAudioException.h"

@implementation YBAudioFilePlayer {
    AudioFileID _audioFileID;
}

- (void)setFileURL:(NSURL *)fileURL {
    [self setFileURL:fileURL typeHint:0];
}

- (void)setFileURL:(NSURL *)fileURL typeHint:(AudioFileTypeID)typeHint {
    if ([_fileURL isEqual:fileURL]) {
        return;
    }
    
    _fileURL = fileURL;
    
    YBAudioThrowIfErr(AudioFileOpenURL((__bridge CFURLRef)fileURL, kAudioFileReadPermission, typeHint, &_audioFileID));
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFileIDs, kAudioUnitScope_Global, 0, _audioFileID, sizeof(AudioFileID)));
    
    
    
    
    // Get number of audio packets in the file:
    UInt32 nPackets = 0;
    UInt32 propsize = sizeof(nPackets);
    YBAudioThrowIfErr(AudioFileGetProperty(_audioFileID, kAudioFilePropertyAudioDataPacketCount, &propsize, &nPackets));
    
    // Get file's asbd:
    AudioStreamBasicDescription fileASBD = {0};
    propsize = sizeof(fileASBD);
    YBAudioThrowIfErr(AudioFileGetProperty(_audioFileID, kAudioFilePropertyDataFormat, &propsize, &fileASBD));
    
    // Tell the file player AU to play the entire file and with which point in the graph's time it should start (at time 0)
    // This makes sure the players start at the same time and stay perfectly sync.
    ScheduledAudioFileRegion rgn = {0};
    memset (&rgn.mTimeStamp, 0, sizeof(rgn.mTimeStamp));
    rgn.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
    rgn.mTimeStamp.mSampleTime = 0;
    rgn.mCompletionProc = NULL;
    rgn.mCompletionProcUserData = NULL;
    rgn.mAudioFile = _audioFileID;
    rgn.mLoopCount = 0;
    rgn.mStartFrame = 0;
    rgn.mFramesToPlay = nPackets * fileASBD.mFramesPerPacket;
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &rgn, sizeof(ScheduledAudioFileRegion)));
    
    // prime the file player AU with default values
    UInt32 defaultVal = 0;
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduledFilePrime, kAudioUnitScope_Global, 0, &defaultVal, sizeof(defaultVal)));
    
    // tell the file player AU when to start playing (-1 sample time means next render cycle)
    AudioTimeStamp startTime;
    memset (&startTime, 0, sizeof(startTime));
    startTime.mFlags = kAudioTimeStampSampleTimeValid;
    startTime.mSampleTime = -1;
    YBAudioThrowIfErr(AudioUnitSetProperty(_auAudioUnit, kAudioUnitProperty_ScheduleStartTimeStamp, kAudioUnitScope_Global, 0, &startTime, sizeof(startTime)));
}

@synthesize fileURL = _fileURL;
@end
