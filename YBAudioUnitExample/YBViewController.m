//
//  YBViewController.m
//  YBAudioUnitExample
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBViewController.h"
#import "YBAudioUnit.h"
#import "YBParameterViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YBViewController ()

@end

@implementation YBViewController {
    __weak IBOutlet UIButton *startStopButton;
    __weak IBOutlet UILabel *timeLabel;
    NSTimer *timer;
    
    YBAudioUnitGraph *graph;
    YBMultiChannelMixer *mixerNode;
    YBDistortionFilter *distortionFilter;
    YBTremeloFilter *tremoloFilter;
    YBAudioFilePlayer *guitarPlayerNode;
    YBAudioFilePlayer *bandPlayerNode;
}

- (void)setupGraph {
    // Create an audio processing graph:
    graph = [[YBAudioUnitGraph alloc] init];
    
    // IO:
    YBAudioUnitNode *ioNode = [graph addNodeWithType:YBAudioComponentTypeRemoteIO];
    
    // Mixer:
    mixerNode = [graph addNodeWithType:YBAudioComponentTypeMultiChannelMixer];
    [mixerNode setMaximumFramesPerSlice:4096]; // optional, enables playback during screen lock
    [mixerNode setBusCount:2 scope:kAudioUnitScope_Input]; // define 2 inputs busses on the mixer
    [mixerNode connectOutput:0 toInput:0 ofNode:ioNode];
    
    // Distortion filter:
    distortionFilter = [graph addNodeWithType:YBAudioComponentTypeDistortion];
    distortionFilter.delay = 500.;
    [distortionFilter connectOutput:0 toInput:0 ofNode:mixerNode];
    
//    tremoloFilter = [graph addNodeWithType:YBAudioComponentTypeTremolo];
    
    {   // Guitar file player:
        guitarPlayerNode = [graph addNodeWithType:YBAudioComponentTypeAudioFilePlayer];
        [guitarPlayerNode connectOutput:0 toInput:0 ofNode:distortionFilter];
        
        NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"guitar" withExtension:@"m4a"];
        [guitarPlayerNode setFileURL:fileURL typeHint:kAudioFileM4AType];
        [guitarPlayerNode scheduleEntireFilePrimeAndStartImmediately];
    }
    
    {   // Band file player:
        bandPlayerNode = [graph addNodeWithType:YBAudioComponentTypeAudioFilePlayer];
        [bandPlayerNode connectOutput:0 toInput:1 ofNode:mixerNode];
        
        NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"band" withExtension:@"m4a"];
        [bandPlayerNode setFileURL:fileURL typeHint:kAudioFileM4AType];
        [bandPlayerNode scheduleEntireFilePrimeAndStartImmediately];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGraph];
    
    // Use KVO (key value observation) on the `running` property of the graph, so we can set the button's label accordingly
    [graph addObserver:self forKeyPath:@"running" options:0 context:NULL];
    
}

- (void)viewDidUnload {
    timeLabel = nil;
    [super viewDidUnload];
    startStopButton = nil;
    graph = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:1./60. target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [timer invalidate]; timer = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"running"]) {
            [startStopButton setTitle:([graph isRunning]) ? @"Stop Graph" : @"Start Graph" forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)updateTimeLabel {
    AudioTimeStamp timeStamp = [guitarPlayerNode currentPlayTime];
    timeLabel.text = [NSString stringWithFormat:@"%.0f", timeStamp.mSampleTime];
}

- (IBAction)toggleStartStop:(id)sender {
    if ([graph isRunning]) {
        [graph stop];
    } else {
        [graph start];
    }
}

- (IBAction)enableMixerInputAction:(UISwitch*)sender {
    [mixerNode setInputEnabled:[sender isOn] forBus:[sender tag]];
}

- (IBAction)mixerLevelAction:(UISlider*)sender {
    [mixerNode setVolume:[sender value] forBus:[sender tag]];
}

- (IBAction)mixerPanAction:(UISlider*)sender {
    [mixerNode setBalance:[sender value] forBus:[sender tag]];
}

- (IBAction)rescheduleAction:(id)sender {
    [guitarPlayerNode unschedule];
    [guitarPlayerNode scheduleEntireFilePrimeAndStartImmediately];
    [bandPlayerNode unschedule];
    [bandPlayerNode scheduleEntireFilePrimeAndStartImmediately];
}

- (IBAction)distortionAction:(id)sender {
    YBParameterViewController *filterViewController = [[YBParameterViewController alloc] init];
    filterViewController.filter = distortionFilter;
    [self.navigationController pushViewController:filterViewController animated:YES];
}

- (IBAction)bypassDistortion:(UISwitch*)sender {
    [distortionFilter setBypass:![sender isOn]];
}

@end
