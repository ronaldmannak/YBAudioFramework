//
//  YBAudioUnitTests.m
//  YBAudioUnitTests
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioUnitTests.h"
#import "YBAudioUnit.h"
#import "YBAudioUtils.h"
#import "YBAudioFilePlayer.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define YBTestsGraphWithNodeType(graph, node, type) \
YBAudioUnitGraph* graph = [[YBAudioUnitGraph alloc] init]; \
YBAudioUnitNode* node = [graph addNodeWithType:type];

@implementation YBAudioUnitTests

- (void)testAddRemoveNodeAndCount {
    YBTestsGraphWithNodeType(graph, node, YBAudioComponentTypeRemoteIO);
    STAssertTrue([[graph nodes] count] == 1, nil);
    [graph start];
    [graph stop];
    [graph removeNode:node];
    STAssertTrue([[graph nodes] count] == 0, nil);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"running"]) {
        BOOL* kvoBool = (BOOL*)context;
        *kvoBool = [object isRunning];
    }
}

- (void)testStartStopIsRunning {
    YBTestsGraphWithNodeType(graph, node, YBAudioComponentTypeRemoteIO);
    BOOL kvoBool;
    [graph addObserver:self forKeyPath:@"running" options:0 context:&kvoBool];
    STAssertTrue([graph isRunning] == NO, nil);
    STAssertTrue(kvoBool == NO, nil);
    [graph start];
    STAssertTrue([graph isRunning] == YES, nil);
    STAssertTrue(kvoBool == YES, nil);
    [graph stop];
    STAssertTrue([graph isRunning] == NO, nil);
    STAssertTrue(kvoBool == NO, nil);
    [graph setRunning:YES];
    STAssertTrue([graph isRunning] == YES, nil);
    STAssertTrue(kvoBool == YES, nil);
    [graph setRunning:NO];
    STAssertTrue([graph isRunning] == NO, nil);
    STAssertTrue(kvoBool == NO, nil);
    [graph removeNode:node];
    [graph removeObserver:self forKeyPath:@"running"];
}

- (void)testMaximumFramesPerSliceAccessors {
    YBTestsGraphWithNodeType(graph, node, YBAudioComponentTypeRemoteIO);
    [graph start];
    [node setMaximumFramesPerSlice:4096];
    STAssertTrue([node maximumFramesPerSlice] == 4096, nil);
    [node setMaximumFramesPerSlice:256];
    STAssertTrue([node maximumFramesPerSlice] == 256, nil);
}

- (void)testStreamFormatAccessors {
    YBTestsGraphWithNodeType(graph, node, YBAudioComponentTypeMultiChannelMixer);
    AudioStreamBasicDescription asbdIn = {0};
    YBSetStreamFormatAUCanonical(&asbdIn, 2, 44100., YES);
    [node setStreamFormat:&asbdIn scope:kAudioUnitScope_Input bus:0];
    AudioStreamBasicDescription asbdOut = {0};
    [node getStreamFormat:&asbdOut scope:kAudioUnitScope_Input bus:0];
    STAssertTrue(memcmp(&asbdIn, &asbdOut, sizeof(AudioStreamBasicDescription)) == 0, nil);
}

- (void)testSampleRateAccessors {
    YBTestsGraphWithNodeType(graph, node, YBAudioComponentTypeRemoteIO);
    [graph start];
    STAssertNoThrow([node setSampleRate:44100. scope:kAudioUnitScope_Output bus:0], nil);
    STAssertTrue([node sampleRateInScope:kAudioUnitScope_Output bus:0] == 44100., nil);
    STAssertNoThrow([graph updateSynchronous], nil);
// TODO: investigate why this doesn't work:
//    STAssertNoThrow([node setSampleRate:22050. scope:kAudioUnitScope_Output bus:0], nil);
//    STAssertTrue([node sampleRateInScope:kAudioUnitScope_Output bus:0] == 22050., nil);
}

- (void)testBypassAccessors {
    /* TODO
    YBTestsGraphWithNodeType(graph, ioNode, YBAudioComponentTypeRemoteIO);
    YBAudioUnitNode *filterNode = [graph addNodeWithType:YBAudioComponentTypeDistortion];
    [filterNode setBypass:YES];
    STAssertTrue([filterNode bypass] == YES, nil);
     */
}

- (void)testBusCountAccessors {
    YBTestsGraphWithNodeType(graph, ioNode, YBAudioComponentTypeRemoteIO);
    YBMultiChannelMixer *mixerNode = [graph addNodeWithType:YBAudioComponentTypeMultiChannelMixer];
    YBAudioUnitNode *playerNode1 = [graph addNodeWithType:YBAudioComponentTypeAudioFilePlayer];
    YBAudioUnitNode *playerNode2 = [graph addNodeWithType:YBAudioComponentTypeAudioFilePlayer];
    [mixerNode setBusCount:2 scope:kAudioUnitScope_Input];
    [mixerNode connectOutput:0 toInput:0 ofNode:ioNode];
    [mixerNode connectInput:0 toOutput:0 ofNode:playerNode1];
    [mixerNode connectInput:1 toOutput:0 ofNode:playerNode2];
    STAssertNoThrow([graph start], nil);
    
    YBAudioUnitNode *playerNode3 = [graph addNodeWithType:YBAudioComponentTypeAudioFilePlayer];
    [mixerNode setBusCount:3 scope:kAudioUnitScope_Input];
    [mixerNode connectInput:3 toOutput:0 ofNode:playerNode3];
    STAssertNoThrow([graph updateSynchronous], nil);
}

- (void)testDisconnectWithoutConnection {
    YBTestsGraphWithNodeType(graph, ioNode, YBAudioComponentTypeRemoteIO);
    STAssertThrows([ioNode disconnectInput:0], nil);
}

- (void)testConnectDisconnect {
    YBTestsGraphWithNodeType(graph, ioNode, YBAudioComponentTypeRemoteIO);
    YBAudioUnitNode *mixerNode = [graph addNodeWithType:YBAudioComponentTypeMultiChannelMixer];
    [graph start];
    [mixerNode connectOutput:0 toInput:0 ofNode:ioNode];
    STAssertNoThrow([graph updateSynchronous], nil);
    [ioNode disconnectInput:0];
    STAssertNoThrow([graph updateSynchronous], nil);
    // Disconnecting again should throw an exception:
    [ioNode disconnectInput:0];    
    STAssertThrows([graph updateSynchronous], nil);
}

- (void)testCPULoad {
    YBTestsGraphWithNodeType(graph, ioNode, YBAudioComponentTypeRemoteIO);
    [ioNode connectInput:1 toOutput:0 ofNode:ioNode];
    [graph start];
    float CPULoad = -1.f;
    float maxCPULoad = -1.f;
    CPULoad = [graph CPULoad];
    maxCPULoad = [graph maxCPULoad];
    STAssertTrue(CPULoad >= 0.f, nil);
    STAssertTrue(maxCPULoad >= 0.f, nil);
}

- (void)testAudioFilePlayerUnit {
    YBTestsGraphWithNodeType(graph, ioNode, YBAudioComponentTypeRemoteIO);
    YBAudioFilePlayer *playerNode = (YBAudioFilePlayer*)[graph addNodeWithType:YBAudioComponentTypeAudioFilePlayer];
    [ioNode connectInput:0 toOutput:0 ofNode:playerNode];
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"guitar" withExtension:@"m4a"];
    [playerNode setFileURL:fileURL typeHint:kAudioFileM4AType];
    [playerNode scheduleEntireFilePrimeAndStartImmediately];
    [graph start];
    // Let it play for a very short time:
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
}

- (void)testMixerUnit {
    YBTestsGraphWithNodeType(graph, ioNode, YBAudioComponentTypeRemoteIO);
    YBMultiChannelMixer *mixerNode = [graph addNodeWithType:YBAudioComponentTypeMultiChannelMixer];
    [mixerNode setBusCount:1 scope:kAudioUnitScope_Input];
    [mixerNode connectOutput:0 toInput:0 ofNode:ioNode];
    [graph start];
    [mixerNode setBalance:-1 forBus:0];
    [graph updateSynchronous];
    [mixerNode setVolume:0.5 forBus:0];
    [graph updateSynchronous];
    [mixerNode setInputEnabled:NO forBus:0];
    [graph updateSynchronous];
    [mixerNode setInputEnabled:YES forBus:0];
    [graph updateSynchronous];
    [mixerNode setVolume:2.0 forBus:0];
    [graph updateSynchronous];
    [mixerNode setBalance:1 forBus:0];
    [graph updateSynchronous];
}

@end
