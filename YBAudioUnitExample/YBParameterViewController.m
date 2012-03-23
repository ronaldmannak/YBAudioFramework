//
//  YBParameterViewController.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/22/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBParameterViewController.h"

@implementation YBParameterViewController {
    YBDistortionFilter *_filter;
    __weak IBOutlet UIScrollView *scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(320.f, 812.f);
}

- (IBAction)sliderAction:(UISlider *)sender {
    float value = [sender value];
    switch ([sender tag]) {
        case 0: _filter.delay = value; break;
        case 1: _filter.decay = value; break;
        case 2: _filter.delayMix = value; break;
        case 3: _filter.decimation = value; break;
        case 4: _filter.rounding = value; break;
        case 5: _filter.decimationMix = value; break;
        case 6: _filter.linearTerm = value; break;
        case 7: _filter.squaredTerm = value; break;
        case 8: _filter.cubicTerm = value; break;
        case 9: _filter.polynomialMix = value; break;
        case 10: _filter.ringModFreq1 = value; break;
        case 11: _filter.ringModFreq2 = value; break;
        case 12: _filter.ringModBalance = value; break;
        case 13: _filter.ringModMix = value; break;
        case 14: _filter.softClipGain = value; break;
        case 15: _filter.finalMix = value; break;
    }
}

@synthesize filter = _filter;
- (void)viewDidUnload {
    scrollView = nil;
    [super viewDidUnload];
}
@end
