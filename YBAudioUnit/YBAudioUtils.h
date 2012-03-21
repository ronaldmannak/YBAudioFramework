//
//  YBAudioUtils.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

void YBSetStreamFormatAUCanonical(AudioStreamBasicDescription* asbd, UInt32 nChannels, Float64 sampleRate, BOOL interleaved);
NSString* YBCoreAudioObjectToString(void *object);