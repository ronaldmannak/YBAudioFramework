//
//  YBMultiChannelMixer.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/22/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBMultiChannelMixer.h"
#import "YBAudioException.h"

@implementation YBMultiChannelMixer

- (void)setInputEnabled:(BOOL)enabled forBus:(AudioUnitElement)bus {
    AudioUnitParameterValue isOn = (AudioUnitParameterValue)enabled;
    YBAudioThrowIfErr(AudioUnitSetParameter(_auAudioUnit, kMultiChannelMixerParam_Enable, kAudioUnitScope_Input, bus, isOn, 0));
}

- (BOOL)isInputEnabledForBus:(AudioUnitElement)bus {
    AudioUnitParameterValue isOn;
    YBAudioThrowIfErr(AudioUnitGetParameter(_auAudioUnit, kMultiChannelMixerParam_Enable, kAudioUnitScope_Input, bus, &isOn));
    return (isOn == 1.) ? YES : NO;
}

- (void)setVolume:(AudioUnitParameterValue)level forBus:(AudioUnitElement)bus {
    YBAudioThrowIfErr(AudioUnitSetParameter(_auAudioUnit, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, bus, level, 0));
}

- (AudioUnitParameterValue)volumeForBus:(AudioUnitElement)bus {
    AudioUnitParameterValue volume;
    YBAudioThrowIfErr(AudioUnitGetParameter(_auAudioUnit, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, bus, &volume));
    return volume;
}

- (void)setBalance:(AudioUnitParameterValue)pan forBus:(AudioUnitElement)bus {
    YBAudioThrowIfErr(AudioUnitSetParameter(_auAudioUnit, kMultiChannelMixerParam_Pan, kAudioUnitScope_Input, bus, pan, 0));
}

- (AudioUnitParameterValue)balanceForBus:(AudioUnitElement)bus {
    AudioUnitParameterValue pan;
    YBAudioThrowIfErr(AudioUnitGetParameter(_auAudioUnit, kMultiChannelMixerParam_Pan, kAudioUnitScope_Input, bus, &pan));
    return pan;
}

@end
