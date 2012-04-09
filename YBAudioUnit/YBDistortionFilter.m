//
//  YBDistortionFilter.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/22/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBDistortionFilter.h"
#import "YBAudioUtils.h"

@implementation YBDistortionFilter

@dynamic delay;
@dynamic decay;
@dynamic delayMix;
@dynamic decimation;
@dynamic rounding;
@dynamic decimationMix;
@dynamic linearTerm;
@dynamic squaredTerm;
@dynamic cubicTerm;
@dynamic polynomialMix;
@dynamic ringModFreq1;
@dynamic ringModFreq2;
@dynamic ringModBalance;
@dynamic ringModMix;
@dynamic softClipGain;
@dynamic finalMix;

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
    YBAudioUnitResolveAccessorPair(delay, Delay, kDistortionParam_Delay, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(decay, Decay, kDistortionParam_Decay, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(delayMix, DelayMix, kDistortionParam_DelayMix, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(decimation, Decimation, kDistortionParam_Decimation, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(decimationMix, DecimationMix, kDistortionParam_DecimationMix, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(linearTerm, LinearTerm, kDistortionParam_LinearTerm, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(squaredTerm, SquaredTerm, kDistortionParam_SquaredTerm, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(cubicTerm, CubicTerm, kDistortionParam_CubicTerm, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(polynomialMix, PolynomialMix, kDistortionParam_PolynomialMix, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(ringModFreq1, RingModFreq1, kDistortionParam_RingModFreq1, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(ringModFreq2, RingModFreq2, kDistortionParam_RingModFreq2, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(ringModBalance, RingModBalance, kDistortionParam_RingModBalance, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(ringModMix, RingModMix, kDistortionParam_RingModMix, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(softClipGain, SoftClipGain, kDistortionParam_SoftClipGain, kAudioUnitScope_Global, 0);
    YBAudioUnitResolveAccessorPair(finalMix, FinalMix, kDistortionParam_FinalMix, kAudioUnitScope_Global, 0);
    return [super resolveInstanceMethod:aSEL];
}

@end
