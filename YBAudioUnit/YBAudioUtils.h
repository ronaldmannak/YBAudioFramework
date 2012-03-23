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

#define YBAudioUnitResolveAccessorPair(__lowercaseParam__, __capitalizedParam__, __AUParamID__, __Scope__, __Element__) \
if (aSEL == @selector(set##__capitalizedParam__:)) { \
return [self resolveParameterAccessor:(YBParameterAccessorDescription){@selector(set##__capitalizedParam__:), __AUParamID__, __Scope__, __Element__, YES}]; \
} \
if (aSEL == @selector(__lowercaseParam__)) { \
return [self resolveParameterAccessor:(YBParameterAccessorDescription){@selector(__lowercaseParam__), __AUParamID__, __Scope__, __Element__, NO}]; \
}
