//
//  YBTremoloFilter.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/22/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBTremoloFilter.h"
#import "YBAudioException.h"
#import "YBAudioComponent.h"

const OSType kAudioUnitSubType_Tremolo = 'trlo';

@implementation YBTremoloFilter

static AudioComponent TremoloComponent = NULL;
static AudioComponentPlugInInterface* TremoloPluginFactory(const AudioComponentDescription *inDesc);
static OSStatus	 Open(void *self, AudioComponentInstance mInstance);
static OSStatus Close(void *self);
static AudioComponentMethod Lookup(SInt16 selector);

static AudioComponentPlugInInterface* TremoloPluginFactory(const AudioComponentDescription *inDesc) {
    static AudioComponentPlugInInterface TremoloInterface = { &Open, &Close, &Lookup, NULL };
    return &TremoloInterface;
}

static OSStatus	 Open(void *self, AudioComponentInstance mInstance) {
    return noErr;
}

static OSStatus Initialize(void *self, ...) {
    return noErr;
}

static OSStatus Default(void *self, ...) {
    return noErr;
}

static OSStatus SetProperty(void *self, ...) {
    return noErr;
}

static OSStatus Render(AudioUnit inUnit, AudioUnitRenderActionFlags  *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32                      inOutputBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
    
    return noErr;
}

static OSStatus Uninitialize(void *self, ...) {
    return noErr;
}


static OSStatus Close(void *self) {
    return noErr;
}

static AudioComponentMethod Lookup(SInt16 selector) {
    switch (selector) {
        case kAudioUnitInitializeSelect: return (AudioComponentMethod) &Initialize;
        case kAudioUnitUninitializeSelect: return (AudioComponentMethod) &Uninitialize;
        case kAudioUnitRenderSelect: return (AudioComponentMethod) &Render;
        case kAudioUnitSetPropertySelect: return (AudioComponentMethod) &SetProperty;
    }
    
    return (AudioComponentMethod) &Default;
    
    /*
     kAudioUnitRange							= 0x0000,	// range of selectors for audio units
     kAudioUnitInitializeSelect				= 0x0001,
     kAudioUnitUninitializeSelect			= 0x0002,
     kAudioUnitGetPropertyInfoSelect			= 0x0003,
     kAudioUnitGetPropertySelect				= 0x0004,
     kAudioUnitSetPropertySelect				= 0x0005,
     kAudioUnitAddPropertyListenerSelect		= 0x000A,
     kAudioUnitRemovePropertyListenerSelect	= 0x000B,
     kAudioUnitRemovePropertyListenerWithUserDataSelect = 0x0012,
     kAudioUnitAddRenderNotifySelect			= 0x000F,
     kAudioUnitRemoveRenderNotifySelect		= 0x0010,
     kAudioUnitGetParameterSelect			= 0x0006,
     kAudioUnitSetParameterSelect			= 0x0007,
     kAudioUnitScheduleParametersSelect		= 0x0011,
     kAudioUnitRenderSelect					= 0x000E,
     kAudioUnitResetSelect					= 0x0009,
     kAudioUnitComplexRenderSelect			= 0x0013,
     kAudioUnitProcessSelect					= 0x0014,
     kAudioUnitProcessMultipleSelect			= 0x0015
     */
    return NULL;
}

+ (void)load {
    AudioComponentDescription inDesc = {kAudioUnitType_Effect, kAudioUnitSubType_Tremolo, kAudioUnitManufacturer_Yobble, 0, 0};
    TremoloComponent = AudioComponentRegister(&inDesc, CFSTR("Yobble Tremelo Filter AudioUnit"), 0, &TremoloPluginFactory);
}

@end
