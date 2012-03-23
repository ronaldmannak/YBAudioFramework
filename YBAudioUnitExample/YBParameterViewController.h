//
//  YBParameterViewController.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/22/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBDistortionFilter.h"

@interface YBParameterViewController : UIViewController
@property (nonatomic, readwrite, strong) YBDistortionFilter *filter;
@end
