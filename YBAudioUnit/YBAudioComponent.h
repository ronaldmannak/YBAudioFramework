//
//  YBAudioComponent.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    /** Converters */
    YBAudioComponentTypeConverter,
    YBAudioComponentTypeVariSpeed,
    YBAudioComponentTypeiPodTime,
    YBAudioComponentTypeiPodTimeOther,
    
    /** Effects */
    YBAudioComponentTypePeakLimiter,
    YBAudioComponentTypeDynamicsProcessor,
    YBAudioComponentTypeReverb2,
    YBAudioComponentTypeLowPassFilter,
    YBAudioComponentTypeHighPassFilter,
    YBAudioComponentTypeBandPassFilter,
    YBAudioComponentTypeHighShelfFilter,
    YBAudioComponentTypeLowShelfFilter,
    YBAudioComponentTypeParametricEQ,
    YBAudioComponentTypeDistortion,
    YBAudioComponentTypeiPodEQ,
    YBAudioComponentTypeNBandEQ,
    
    /** Mixers */
    YBAudioComponentTypeMultiChannelMixer,
    YBAudioComponentType3DMixerEmbedded,
    
    /** Generators */
    YBAudioComponentTypeScheduledSoundPlayer,
    YBAudioComponentTypeAudioFilePlayer,
    
    /** Music Instruments */
    YBAudioComponentTypeSampler,
    
    /** Input/Output */
    YBAudioComponentTypeGenericOutput,
    YBAudioComponentTypeRemoteIO,
    YBAudioComponentTypeVoiceProcessingIO
    
} YBAudioComponentType;

@interface YBAudioComponent : NSObject @end
