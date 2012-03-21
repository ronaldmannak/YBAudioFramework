//
//  YBAudioUnitGraph.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "YBAudioComponent.h"

@class YBAudioUnitNode;

/**
	YBAudioUnitGraph represents audio processing graphs.
    A graph instance serves as a factory for processing nodes, which are instances of YBAudioUnitNode.
    Using the -addNodeWithType: method, new processing nodes can be created.
    
    To direct the audio flow within the graph, use the -connect... and -disconnect... methods to make
    and break connections between the input and output busses of audio processing nodes.
 
    When making changes to the state of the graph while the graph is running, you need to call
    one of the update methods to commit the changes.
 */

@interface YBAudioUnitGraph : NSObject

/**
	Read-only set with YBAudioUnitNode instances that have been added to the receiver.
 */
@property (nonatomic, readonly, strong) NSSet *nodes;

/**
	Read-only float value representing the current CPU load.
 */
@property (nonatomic, readonly, assign) float CPULoad;

/**
 Read-only float value representing the maximum CPU load since the last call or start of the graph.
 */
@property (nonatomic, readonly, assign) float maxCPULoad;


/**
    Read-write BOOL that indicates whether the graph is currently running. Supports KVO.
 */
@property (nonatomic, readwrite, assign, setter = setRunning:, getter = isRunning) BOOL running;

/**
    Method to add a new audio component nodes to the receiver base on a component type identifier.
 */
- (YBAudioUnitNode*)addNodeWithType:(YBAudioComponentType)type;

/**
    Method to remove a node from the receiver.
 */
- (void)removeNode:(YBAudioUnitNode*)node;

/**
    Methods to start or stop the audio processing
    @see -isRunning and -setRunning:
 */
- (void)start;
- (void)stop;

/**
    Methods to make and break connections between busses of nodes
 */
- (void)connectInput:(AudioUnitElement)inBus ofNode:(YBAudioUnitNode*)inNode toOutput:(AudioUnitElement)outBus ofNode:(YBAudioUnitNode*)outNode;
- (void)connectOutput:(AudioUnitElement)outBus ofNode:(YBAudioUnitNode*)outNode toInput:(AudioUnitElement)inBus ofNode:(YBAudioUnitNode*)inNode;
- (void)disconnectInput:(AudioUnitElement)inBus ofNode:(YBAudioUnitNode*)inNode;
- (void)disconnectAll;

/**
    Update methods to commit changes the state of a running graph
 */
- (BOOL)updateWithError:(NSError*__autoreleasing*)error;
- (void)updateSynchronous;

@end




@interface YBAudioUnitGraph (LowerLevel)

- (YBAudioUnitNode*)addNodeWithAUDescription:(AudioComponentDescription *)description;
- (YBAudioUnitNode*)addNodeWithAUDescription:(AudioComponentDescription *)description wrapperClass:(Class)nodeClass;

@end
