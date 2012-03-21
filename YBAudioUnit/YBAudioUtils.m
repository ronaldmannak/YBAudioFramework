//
//  YBAudioUtils.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioUtils.h"

void YBSetStreamFormatAUCanonical(AudioStreamBasicDescription* asbd, UInt32 nChannels, Float64 sampleRate, BOOL interleaved) {
    asbd->mSampleRate = sampleRate;
    asbd->mFormatID = kAudioFormatLinearPCM;
#if CA_PREFER_FIXED_POINT
    asbd->mFormatFlags = kAudioFormatFlagsCanonical | (kAudioUnitSampleFractionBits << kLinearPCMFormatFlagsSampleFractionShift);
#else
    asbd->mFormatFlags = kAudioFormatFlagsCanonical;
#endif
    asbd->mChannelsPerFrame = nChannels;
    asbd->mFramesPerPacket = 1;
    asbd->mBitsPerChannel = 8 * (UInt32)sizeof(AudioUnitSampleType);
    if (interleaved) {
        asbd->mBytesPerPacket = asbd->mBytesPerFrame = nChannels * (UInt32)sizeof(AudioUnitSampleType);
    } else {
        asbd->mBytesPerPacket = asbd->mBytesPerFrame = (UInt32)sizeof(AudioUnitSampleType);
        asbd->mFormatFlags |= kAudioFormatFlagIsNonInterleaved;
    }
}

static int dataWrite(void *context, const char *buffer, int count) {
    NSMutableData * descriptionData = (__bridge NSMutableData*)context;
    [descriptionData appendBytes:buffer length:count];
    return 0;
}

NSString* YBCoreAudioObjectToString(void * object) {
    NSMutableData * descriptionData = [NSMutableData data];
    FILE *inMemoryFile = fwopen((__bridge void*)descriptionData, dataWrite);
    CAShowFile(object, inMemoryFile);
    fclose(inMemoryFile);
    
    NSString *description = [[NSString alloc] initWithData:descriptionData encoding:NSUTF8StringEncoding];
    return description;
}