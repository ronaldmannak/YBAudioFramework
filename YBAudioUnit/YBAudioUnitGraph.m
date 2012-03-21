//
//  YBAudioUnitGraph.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioUnitGraph.h"
#import "YBAudioException.h"
#import "YBAudioUnitNode.h"
#import "YBAudioUtils.h"

NSString* YBAudioUnitErrorDomain = @"YBAudioUnitErrorDomain";

@interface YBAudioUnitGraph (Internal)
- (AUGraph)AUGraph;
@end

@interface YBAudioComponent (Internal)
+ (void)fillOutComponentDescription:(AudioComponentDescription*)description withType:(YBAudioComponentType)type;
+ (Class)wrapperClassForComponentType:(YBAudioComponentType)type;
@end

@interface YBAudioUnitNode (Internal)
- (id)initWithAUNode:(AUNode)auNode audioUnit:(AudioUnit)auAudioUnit inGraph:(YBAudioUnitGraph *)graph;
- (AUNode)AUNode;
@end

@implementation YBAudioUnitGraph {
    AUGraph _auGraph;
    __strong NSMutableSet *_nodes;
}

- (id)init {
    self = [super init];
    if (self) {
        YBAudioThrowIfErr(NewAUGraph(&_auGraph));
        YBAudioThrowIfErr(AUGraphOpen(_auGraph));
        YBAudioThrowIfErr(AUGraphInitialize(_auGraph));
        _nodes = [NSMutableSet set];
    }
    return self;
}

- (void)dealloc {
    [_nodes removeAllObjects];
    YBAudioThrowIfErr(AUGraphUninitialize(_auGraph));
    YBAudioThrowIfErr(AUGraphClose(_auGraph));
    YBAudioThrowIfErr(DisposeAUGraph(_auGraph));
}

- (YBAudioUnitNode*)addNodeWithType:(YBAudioComponentType)type {
    AudioComponentDescription description;
    [YBAudioComponent fillOutComponentDescription:&description withType:type];
    Class wrapperClass = [YBAudioComponent wrapperClassForComponentType:type];
    return [self addNodeWithAUDescription:&description wrapperClass:wrapperClass];
}

- (YBAudioUnitNode*)addNodeWithAUDescription:(AudioComponentDescription *)description {
    return [self addNodeWithAUDescription:description wrapperClass:[YBAudioUnitNode class]];
}

- (YBAudioUnitNode*)addNodeWithAUDescription:(AudioComponentDescription *)description wrapperClass:(Class)nodeClass {
    AUNode auNode;
    AudioUnit auAudioUnit;
    YBAudioThrowIfErr(AUGraphAddNode(_auGraph, description, &auNode));
    AUGraphNodeInfo(_auGraph, auNode, NULL, &auAudioUnit);
    YBAudioUnitNode *node = [[nodeClass alloc] initWithAUNode:auNode audioUnit:auAudioUnit inGraph:self];
    [_nodes addObject:node];
    return node;
}

- (void)removeNode:(YBAudioUnitNode*)node {
    YBAudioThrowIfErr(AUGraphRemoveNode(_auGraph, [node AUNode]));
    [_nodes removeObject:node];
}

- (void)start {
    if ([self isRunning]) {
        return;
    }
    [self willChangeValueForKey:@"running"];
    YBAudioThrowIfErr(AUGraphStart(_auGraph));
    [self didChangeValueForKey:@"running"];
}

- (void)stop {
    if ([self isRunning] == NO) {
        return;
    }
    [self willChangeValueForKey:@"running"];
    YBAudioThrowIfErr(AUGraphStop(_auGraph));
    [self didChangeValueForKey:@"running"];
}

- (BOOL)isRunning {
    Boolean outIsRunning;
    YBAudioThrowIfErr(AUGraphIsRunning(_auGraph, &outIsRunning));
    return outIsRunning;
}

- (void)setRunning:(BOOL)running {
    if (running) {
        [self start];
    } else {
        [self stop];
    }
}

- (BOOL)updateWithError:(NSError*__autoreleasing*)error {
    Boolean outIsUpdated;
    OSStatus err = AUGraphUpdate(_auGraph, &outIsUpdated);
    if (error) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
    }
    return outIsUpdated;
}

- (void)updateSynchronous {
    YBAudioThrowIfErr(AUGraphUpdate(_auGraph, NULL));
}

- (void)connectInput:(AudioUnitElement)inBus ofNode:(YBAudioUnitNode*)inNode toOutput:(AudioUnitElement)outBus ofNode:(YBAudioUnitNode*)outNode {
    YBAudioThrowIfErr(AUGraphConnectNodeInput(_auGraph, [outNode AUNode], outBus, [inNode AUNode], inBus));
}

- (void)connectOutput:(AudioUnitElement)outBus ofNode:(YBAudioUnitNode*)outNode toInput:(AudioUnitElement)inBus ofNode:(YBAudioUnitNode*)inNode {
    YBAudioThrowIfErr(AUGraphConnectNodeInput(_auGraph, [outNode AUNode], outBus, [inNode AUNode], inBus));
}

- (void)disconnectInput:(AudioUnitElement)inBus ofNode:(YBAudioUnitNode*)inNode {
    YBAudioThrowIfErr(AUGraphDisconnectNodeInput(_auGraph, [inNode AUNode], inBus));
}

- (void)disconnectAll {
    YBAudioThrowIfErr(AUGraphClearConnections(_auGraph));
}

- (float)CPULoad {
    Float32 cpuLoad;
    YBAudioThrowIfErr(AUGraphGetCPULoad(_auGraph, &cpuLoad));
    return (float)cpuLoad;
}

- (float)maxCPULoad {
    Float32 maxCpuLoad;
    YBAudioThrowIfErr(AUGraphGetMaxCPULoad(_auGraph, &maxCpuLoad));
    return (float)maxCpuLoad;
}

- (AUGraph)UGraph {
    return _auGraph;
}

- (NSString*)description {
    NSString *graphDescription = YBCoreAudioObjectToString(_auGraph);
    return [NSString stringWithFormat:@"<%@ %p>\n%@", [self class], self, graphDescription];
}

@synthesize nodes = _nodes;
@end
