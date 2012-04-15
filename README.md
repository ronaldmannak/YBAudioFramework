YBAudioFramework
================

YBAudioFramework is a convenience wrapper framework around Apple's CoreAudio and in particular the AudioUnit C APIs.
It attempts to abstract away the hairy, meticulous things that you need to deal with when using Apple's APIs.
The framework is still under construction, only a limited set of APIs has been wrapped so far.
It's geared towards iOS 5+, but may also work on OS X.

Working parts
-------------

* Audio graph
* Audio node / unit base class (these are merged into one class for convenience)
* RemoteIO unit (iOS' only audio hardware AudioUnit)
* Multi channel mixer unit
* Scheduled sound player unit
* Audio file player unit
* Distortion filter unit

Roadmap
-------

* Finish varispeed unit
* Wrap more of the standard filter units
* Write more unit tests. It already has pretty decent code coverage, but needs to be improved.
* Create a convenient filter base class (on top of / around Apple's public AUEffectBase C++ class)

Code example
------------

This example is taken from the example app that is part of the framework project.
It creates two audio players, connected to a mixer, connected to the remote IO output of the iDevice.
One of the players also has a distortion effect filter between the output of the player and the input of the mixer.
The first player is primed with an audio file with a guitar track. The second player is primed with a corresponding track of the band playing along.

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

To start the graph's playback:

	[graph start];
    
To stop the graph's playback:

	[graph stop];
	
To change the volume (e.g. 75%) of a channel (e.g. bus 1) on the mixer:

	[mixerNode setVolume:0.75 forBus:1];
