//
//  PlayerViewController.m
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright 2009 Blaenk Denum. All rights reserved.
//

#import "PlayerViewController.h"
#import "DIFMAppDelegate.h"
#import "AudioStreamer.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation PlayerViewController

@synthesize playTime;
@synthesize streamInfo;

@synthesize nowPlayingArtist;
@synthesize nowPlayingSong;

@synthesize volumeView;

@synthesize pauseButton;

- (void)pauseToggle:(id)sender {
    if (![delegate.streamer isPlaying]) {
        // sanity check -- no channel to stream, alert the user
        if (delegate.streamer.url == nil) {
            UIAlertView *noURL = [[UIAlertView alloc] initWithTitle:@"No Channel Specified"
                                                        message:@"You have not chosen a channel to stream."
                                                        delegate:nil
                                                        cancelButtonTitle:@"Ok"
                                                        otherButtonTitles:nil];
            [noURL show];
            [noURL release];
        }
        
        // play the same stream again cause they just paused and pressed play again
//        delegate.streamer = [[AudioStreamer alloc] initWithURL:persistentURL];
//        
//        progressUpdateTimer =
//        [NSTimer
//         scheduledTimerWithTimeInterval:1
//         target:self
//         selector:@selector(updateProgress:)
//         userInfo:nil
//         repeats:YES];
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(playbackStateChanged:)
//         name:ASStatusChangedNotification
//         object:delegate.streamer];
//        
//        [delegate.streamer setDelegate:self];
//        [delegate.streamer setDidUpdateMetaDataSelector:@selector(metaDataUpdated:)];
//        
//        // loading?
//        [pauseButton setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
        
        
        // pause is a toggle method, but it seems to have unpredictable
        // implications on the buffers. perhaps it is better to simply
        // stop the stream and reinitiate it. will have to keep a persistent
        // time in seconds as well as URL
        [delegate.streamer pause];
    } else {
        // pause the stream
        [delegate.streamer pause];
        
        // save the stream progress
        
        // erase the labels here?
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self.pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    formattedTimeString = [[NSMutableString alloc] initWithCapacity:8]; // 12:12:12
    
    delegate = (DIFMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MPVolumeView *mpVolumeView = [[[MPVolumeView alloc] initWithFrame:self.volumeView.bounds] autorelease];
	[self.volumeView addSubview:mpVolumeView];
	[mpVolumeView sizeToFit];
    
    progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.5
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:delegate.streamer];
    
    //[delegate.streamer setDelegate:self];
    delegate.streamer.delegate = self;
    //[delegate.streamer setDidUpdateMetaDataSelector:@selector(metaDataUpdated:)];
    delegate.streamer.didUpdateMetaDataSelector = @selector(metaDataUpdated:);
    
    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [self destroyStreamer]; // get rid of the streamer correctly
    
    if (progressUpdateTimer) // and the timer
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
    
    [playTime release]; // the play time label
    [streamInfo release]; // the stream info label (channel, etc.)
    
    [nowPlayingArtist release]; // the current label artist
    [nowPlayingSong release]; // the current label
    
    [volumeView release];
    
    [pauseButton release]; // the pause button
    
    [formattedTimeString release]; // the formatted time string
    [persistentURL release]; // get rid of the url
    
    [super dealloc];
}

#pragma mark -
#pragma mark Streamer

- (void)metaDataUpdated:(NSString *)metaData {
    // parse the important part
    NSMutableString *parsedMetaData = [NSMutableString stringWithString:metaData];
    [parsedMetaData replaceOccurrencesOfString:@"StreamTitle='" withString:@""];
    [parsedMetaData replaceOccurrencesOfString:@"';StreamUrl='';" withString:@""];
    
    // separate the artist from the song, to be able to present it in a nicer way
    NSArray *stringParts = [parsedMetaData componentsSeparatedByString:@" - "];
    
    self.nowPlayingArtist.text = [stringParts objectAtIndex:0];
    self.nowPlayingSong.text = [stringParts objectAtIndex:1];
}

- (void)updateProgress:(NSTimer *)updatedTimer {
    int totalSeconds = 0;
    
    if ([[DIFMStreamer sharedInstance].audioStreamer isIdle]) {
        totalSeconds = [DIFMStreamer sharedInstance].totalSecondsLapsed;
    } else {
        totalSeconds = (int)[DIFMStreamer sharedInstance].streamer.progress + (int)[DIFMStreamer sharedInstance].totalSecondsLapsed;
    } // need to also test to see 
    
    // empty the string again
    [formattedTimeString setString:@""];
    
    hours = totalSeconds / (60 * 60);
    
    // only show the hour part if there has been hours passed
    if (hours > 0)
        [formattedTimeString appendFormat:@"%02d:", hours];
    
    minutes = (totalSeconds / 60) % 60;
    seconds = totalSeconds % 60;
    
    // format the string
    [formattedTimeString appendFormat:@"%02d:%02d", minutes, seconds];
    
    if (delegate.streamer.bitRate != 0.0) {
        playTime.text = formattedTimeString;
        
        // set stream/channel info - memory problem?
        self.streamInfo.text = [NSString stringWithFormat:@"%@ Channel - %dkbps", delegate.currentChannel, (delegate.streamer.bitRate / 1000)];
	} else {
		self.playTime.text = formattedTimeString;
        
        self.streamInfo.text = @"Nothing Playing";
	}
}

- (void)destroyStreamer {
	if (delegate.streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:delegate.streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[delegate.streamer stop];
		[delegate.streamer release];
		delegate.streamer = nil;
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification {
	if ([delegate.streamer isWaiting])
	{
        [self.pauseButton setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
	}
	else if ([delegate.streamer isPlaying])
	{
        [self.pauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
	}
    else if ([delegate.streamer isPaused])
    {
        [self.pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
	else if ([delegate.streamer isIdle])
	{
        // commented out the stop/reinitiate pause process, which might be better
        //persistentURL = [delegate.streamer.url retain]; // gotta retain it cause it's about to be released
		//[self destroyStreamer];
		[pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	}
}

@end
