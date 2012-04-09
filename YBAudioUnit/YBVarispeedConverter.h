//
//  YBVarispeedConverter.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 4/9/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioUnitNode.h"

@interface YBVarispeedConverter : YBAudioUnitNode

/** Rate, 0.25 -> 4.0, 1.0  */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue playbackRate;

/** Cents, -2400 -> 2400, 0.0 */
@property (nonatomic, readwrite, assign) AudioUnitParameterValue playbackCents;

@end
