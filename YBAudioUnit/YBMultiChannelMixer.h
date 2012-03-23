//
//  YBMultiChannelMixer.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/22/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioUnitNode.h"

@interface YBMultiChannelMixer : YBAudioUnitNode

/**
    Enables or disables (mutes) a mixer input bus.
    @see kMultiChannelMixerParam_Enable
 */
- (void)setInputEnabled:(BOOL)enabled forBus:(AudioUnitElement)bus;
- (BOOL)isInputEnabledForBus:(AudioUnitElement)bus;

/** 
    Accessors for the volume level of a mixer input bus.
    @see kMultiChannelMixerParam_Volume
 */
- (void)setVolume:(AudioUnitParameterValue)level forBus:(AudioUnitElement)bus;
- (AudioUnitParameterValue)volumeForBus:(AudioUnitElement)bus;

/** 
    Accessors for the stereo balance of a mixer input bus.
    @see kMultiChannelMixerParam_Pan
 */
- (void)setBalance:(AudioUnitParameterValue)pan forBus:(AudioUnitElement)bus;
- (AudioUnitParameterValue)balanceForBus:(AudioUnitElement)bus;

@end

