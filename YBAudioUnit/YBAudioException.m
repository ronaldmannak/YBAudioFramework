//
//  YBAudioException.m
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAudioException.h"
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

const char* YBAudioGetErrorStringFromOSStatus(OSStatus error) {
    switch (error) {
        // AUComponent.h Errors:
        case kAudioUnitErr_InvalidProperty:
            return "kAudioUnitErr_InvalidProperty: The property is not supported";
        case kAudioUnitErr_InvalidParameter:
            return "kAudioUnitErr_InvalidParameter: The parameter is not supported";
        case kAudioUnitErr_InvalidElement:
            return "kAudioUnitErr_InvalidElement: The specified element is not valid";
        case kAudioUnitErr_NoConnection:
            return "kAudioUnitErr_NoConnection: There is no connection (generally an audio unit is asked to render but it has not input from which to gather data)";
        case kAudioUnitErr_FailedInitialization:
            return "kAudioUnitErr_FailedInitialization: The audio unit is unable to be initialised";
        case kAudioUnitErr_TooManyFramesToProcess:
            return "kAudioUnitErr_TooManyFramesToProcess: When an audio unit is initialised it has a value which specifies the max number of frames it will be asked to render at any given time. If an audio unit is asked to render more than this, this error is returned.";
        case kAudioUnitErr_InvalidFile:
            return "kAudioUnitErr_InvalidFile: If an audio unit uses external files as a data source, this error is returned if a file is invalid (Apple's DLS synth returns this error)";
        case kAudioUnitErr_FormatNotSupported:
            return "kAudioUnitErr_FormatNotSupported: Returned if an input or output format is not supported";
        case kAudioUnitErr_Uninitialized:
            return "kAudioUnitErr_Uninitialized: Returned if an operation requires an audio unit to be initialised and it is not.";
        case kAudioUnitErr_InvalidScope:
            return "kAudioUnitErr_InvalidScope: The specified scope is invalid";
        case kAudioUnitErr_PropertyNotWritable:
            return "kAudioUnitErr_PropertyNotWritable: The property cannot be written";
        case kAudioUnitErr_CannotDoInCurrentContext:
            return "kAudioUnitErr_CannotDoInCurrentContext or kAUGraphErr_CannotDoInCurrentContext: See docs for more info.";
        case kAudioUnitErr_InvalidPropertyValue:
            return "kAudioUnitErr_InvalidPropertyValue: The property is valid, but the value of the property being provided is not";
        case kAudioUnitErr_PropertyNotInUse:
            return "kAudioUnitErr_PropertyNotInUse: Returned when a property is valid, but it hasn't been set to a valid value at this time";
        case kAudioUnitErr_Initialized:
            return "kAudioUnitErr_Initialized: Indicates the operation cannot be performed because the audio unit is initialized.";
        case kAudioUnitErr_InvalidOfflineRender:
            return "Used to indicate that the offline render operation is invalid. For instance, when the audio unit needs to be pre-flighted, but it hasn't been.";
        case kAudioUnitErr_Unauthorized:
            return "Returned by either Open or Initialise, this error is used to indicate that the audio unit is not authorised, that it cannot be used. A host can then present a UI to notify the user the audio unit is not able to be used in its current state.";
        case kAudioUnitErr_IllegalInstrument:
            return "kAudioUnitErr_IllegalInstrument";
        case kAudioUnitErr_InstrumentTypeNotFound:
            return "kAudioUnitErr_InstrumentTypeNotFound";
        case kAudioUnitErr_UnknownFileType:
            return "kAudioUnitErr_UnknownFileType";
        case kAudioUnitErr_FileNotSpecified:
            return "kAudioUnitErr_FileNotSpecified";
        
        // AUGraph.h Errors:
        case kAUGraphErr_NodeNotFound:
            return "kAUGraphErr_NodeNotFound: The specified node cannot be found";
        case kAUGraphErr_InvalidConnection:
            return "kAUGraphErr_InvalidConnection: The attempted connection between two nodes cannot be made";
        /* case kAUGraphErr_CannotDoInCurrentContext: // Same code as kAudioUnitErr_CannotDoInCurrentContext */
        case kAUGraphErr_OutputNodeErr:
            return "kAUGraphErr_OutputNodeErr: AUGraphs can only contain one OutputUnit. This error is returned if trying to add a second output unit or the graph's output unit is removed while the graph is running";
        case kAUGraphErr_InvalidAudioUnit:
            return "kAUGraphErr_InvalidAudioUnit";
            
        case 561211770:
            return "kAudioHardwareBadPropertySizeError";
            
    }
    return "Not an AudioUnit error code...";
}

void YBAudioThrow(OSStatus errCode, const char *functionInfo, int lineNumber) {
    if (errCode == noErr) {
        return;
    }
    const char *errString = YBAudioGetErrorStringFromOSStatus(errCode);
    NSString *reason = [NSString stringWithFormat:@"Exception at %s [%d]: %s (OSStatus %ld)", functionInfo, lineNumber, errString, errCode];
    NSException *exception = [NSException exceptionWithName:@"YBAudioUnitException" reason:reason userInfo:nil];
    [exception raise];
}
