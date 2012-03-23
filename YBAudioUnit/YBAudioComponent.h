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
    
    YBAudioComponentTypeTremolo,
    
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

extern const OSType kAudioUnitManufacturer_Yobble;

@interface YBAudioComponent : NSObject @end
