//
//  YBDistortionFilter.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/22/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioUnitNode.h"

@interface YBDistortionFilter : YBAudioUnitNode

/** Delay in Milliseconds, 0.1 -> 500, 0.1  */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue delay;

/** Decay rate, 0.1 -> 50, 1.0 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue decay;

/** Delay mix percent, 0 -> 100, 50 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue delayMix;

/** Decimation percent, 0 -> 100 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue decimation;

/** Rounding percent, 0 -> 100, 0 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue rounding;

/** Decimation mix percent, 0 -> 100, 50 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue decimationMix;

/** Linear Gain, 0 -> 1, 1 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue linearTerm;

/** Linear Gain, 0 -> 20, 0 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue squaredTerm;

/** Linear Gain, 0 -> 20, 0 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue cubicTerm;

/** Percent, 0 -> 100, 50 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue polynomialMix;

/** Ring modulation frequency 1 Hertz, 0.5 -> 8000, 100 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue ringModFreq1;

/** Ring modulation frequency 2 Hertz, 0.5 -> 8000, 100 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue ringModFreq2;

/** Ring modulation balance Percent, 0 -> 100, 50 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue ringModBalance;

/** Ring modulation mix Percent, 0 -> 100, 0 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue ringModMix;

/** Soft clip gain in dB, -80 -> 20, -6 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue softClipGain;

/** Final mix Percent, 0 -> 100, 50 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue finalMix;

@end
