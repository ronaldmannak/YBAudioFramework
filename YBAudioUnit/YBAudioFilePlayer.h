//
//  YBAudioFilePlayer.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBScheduledSoundPlayer.h"

/**
	Convenience wrapper for the AudioFilePlayer unit.
    It exposes only certain functionality of the AudioFilePlayer unit.
    For simplicity's sake, only one file at a time can be scheduled for playback.
 
    Using YBScheduledSoundPlayer:
 
    1- Create a player using -[graph addNodeWithType:YBAudioComponentTypeAudioFilePlayer]
    2- Set its fileURL property to the file that you want to open
    3- Set a region that needs to be scheduled using one of the -setRegion... methods
    4- Prime the player's buffers using one of the -primeBuffers... methods
    5- Define the player's starting time using one of the -setStartTimeStamp... methods
 
    For step 3-5 you can also use the convenience method -scheduleEntireFilePrimeAndStartImmediately
 */
@interface YBAudioFilePlayer : YBScheduledSoundPlayer

/**
    Methods to open the audio file that needs to be scheduled.
    Set fileURL to nil to close the audio file.
 */
@property (nonatomic, readwrite, strong) NSURL *fileURL;
- (void)setFileURL:(NSURL *)fileURL typeHint:(AudioFileTypeID)typeHint;

/**
     Read-only property containing the player's current playback time,
     offset from the beginning of the file.
 */
@property (nonatomic, readonly) AudioTimeStamp currentPlayTime;

/**
	Convenience method to set the entire file as scheduled region,
    prime the buffers of the player and set the start time stamp as `now`.
 */
- (void)scheduleEntireFilePrimeAndStartImmediately;

/**
    Convenience method to unschedule the current region and schedule from the specified
    time up to the end of the file. This can be used to `pause` the player unit by giving
    the current playback time. To `continue` playback after `pausing`, send -setStartTimeStampImmediately.
 */
- (void)rescheduleEntireFileBeginningAtPlaybackTime:(AudioTimeStamp)timestamp;

/**
    Convenience method to unschedule and reschedule the entire file beginning at the current
    playback time. This can be used to `pause` the player unit at the current position.
    To `continue` playback after `pausing`, send -setStartTimeStampImmediately.
    @see -rescheduleEntireFileBeginningAtPlaybackTime:
 */
- (void)rescheduleEntireFileBeginningAtCurrentPlaybackTime;

/**
    Methods to set and get the region of the file that is scheduled for playback.
    After setting the region, prime the buffers of the player
    using -primeBuffers or -primeBuffersWithFrames.
    
    @see -primeBuffers
    @see -primeBuffersWithFrames:
    @see kAudioUnitProperty_ScheduledFileRegion
 */
- (void)setRegionEntireFile;
- (void)setRegion:(ScheduledAudioFileRegion*)region;
- (ScheduledAudioFileRegion*)region;

/**
    Methods to prime the buffers of the player.
    This needs to be called after a region has been scheduled for playback.
 
    Use -primeBuffer to use the default number of frames that it should buffer.
    Use -primeBuffersWithFrames: to specify the number of frames.
 
    @see kAudioUnitProperty_ScheduledFilePrime
 */
- (void)primeBuffers;
- (void)primeBuffersWithFrames:(UInt32)numberOfFrames;

@end
