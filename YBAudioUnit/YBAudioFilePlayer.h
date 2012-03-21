//
//  YBAudioFilePlayer.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBScheduledSoundPlayer.h"

@interface YBAudioFilePlayer : YBScheduledSoundPlayer
@property (nonatomic, readwrite, strong) NSURL *fileURL;
@end
