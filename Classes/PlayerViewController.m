//
//  PlayerViewController.m
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright 2009 Blaenk Denum. All rights reserved.
//

#import "PlayerViewController.h"

#import "DIFMStreamer.h"
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
    if (![[DIFMStreamer sharedInstance].audioStreamer isPlaying]) {
        // sanity check -- no channel to stream, alert the user
        if ([DIFMStreamer sharedInstance].persistentURL == nil) {
            UIAlertView *noURL = [[UIAlertView alloc] initWithTitle:@"No Channel Specified"
                                                        message:@"You have not chosen a channel to stream."
                                                        delegate:nil
                                                        cancelButtonTitle:@"Ok"
                                                        otherButtonTitles:nil];
            [noURL show];
            [noURL release];
            
            return;
        }

        // play the same stream again cause they just paused and pressed play again
        [[DIFMStreamer sharedInstance] restartStreamerWithPersistentData];


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
        
        [[DIFMStreamer sharedInstance].audioStreamer setDelegate:self];
        [[DIFMStreamer sharedInstance].audioStreamer setDidUpdateMetaDataSelector:@selector(metaDataUpdated:)];

        // loading?
        //[pauseButton setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
    } else {
        [[DIFMStreamer sharedInstance].audioStreamer stop];
        
        // save the stream progress
        
        // erase the labels here?
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self.pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    formattedTimeString = [[NSMutableString alloc] initWithCapacity:8]; // 12:12:12
    
    MPVolumeView *mpVolumeView = [[[MPVolumeView alloc] initWithFrame:self.volumeView.bounds] autorelease];
	[self.volumeView addSubview:mpVolumeView];
	[mpVolumeView sizeToFit];
    
    progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:1.0
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:[DIFMStreamer sharedInstance].audioStreamer];
    
    //[delegate.streamer setDelegate:self];
    [DIFMStreamer sharedInstance].audioStreamer.delegate = self;
    //[delegate.streamer setDidUpdateMetaDataSelector:@selector(metaDataUpdated:)];
    [DIFMStreamer sharedInstance].audioStreamer.didUpdateMetaDataSelector = @selector(metaDataUpdated:);
    
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
    [[DIFMStreamer sharedInstance] destroyStreamer];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:ASStatusChangedNotification
     object:[DIFMStreamer sharedInstance].audioStreamer];
    [progressUpdateTimer invalidate];
    progressUpdateTimer = nil;
    
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
    
    [super dealloc];
}

#pragma mark -
#pragma mark Streamer

- (void)metaDataUpdated:(NSString *)metaData {
    // parse the important part
    NSMutableString *parsedMetaData = [NSMutableString stringWithString:metaData];
    [parsedMetaData replaceOccurrencesOfString:@"StreamTitle='" withString:@"" options:0 range:NSMakeRange(0, [parsedMetaData length])];
    [parsedMetaData replaceOccurrencesOfString:@"';StreamUrl='';" withString:@"" options:0 range:NSMakeRange(0, [parsedMetaData length])];
    
    // separate the artist from the song, to be able to present it in a nicer way
    NSArray *stringParts = [parsedMetaData componentsSeparatedByString:@" - "];
    
    self.nowPlayingArtist.text = [stringParts objectAtIndex:0];
    self.nowPlayingSong.text = [stringParts objectAtIndex:1];
}

- (void)updateProgress:(NSTimer *)updatedTimer {
    if ([[DIFMStreamer sharedInstance].audioStreamer isPlaying]) {
        [DIFMStreamer sharedInstance].totalSecondsLapsed++;
    }
    
    int totalSeconds = [DIFMStreamer sharedInstance].totalSecondsLapsed;
    
    // empty the string again
    [formattedTimeString setString:@""];
    
    hours = (int)totalSeconds / (60 * 60);
    
    // only show the hour part if there has been hours passed
    if (hours > 0)
        [formattedTimeString appendFormat:@"%02d:", hours];
    
    minutes = (int)(totalSeconds / 60) % 60;
    seconds = (int)totalSeconds % 60;
    
    // format the string
    [formattedTimeString appendFormat:@"%02d:%02d", minutes, seconds];
    
    if ([DIFMStreamer sharedInstance].audioStreamer.bitRate != 0.0) {
        playTime.text = formattedTimeString;
        
        // set stream/channel info - memory problem?
        self.streamInfo.text = [NSString stringWithFormat:@"%@ Channel - %dkbps", [DIFMStreamer sharedInstance].currentChannel, ([DIFMStreamer sharedInstance].audioStreamer.bitRate / 1000)];
	} else {
		self.playTime.text = formattedTimeString;
        
        self.streamInfo.text = @"Nothing Playing";
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification {
	if ([[DIFMStreamer sharedInstance].audioStreamer isWaiting])
	{
        [self.pauseButton setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
	}
	else if ([[DIFMStreamer sharedInstance].audioStreamer isPlaying])
	{
        [self.pauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
	}
    else if ([[DIFMStreamer sharedInstance].audioStreamer isPaused])
    {
        [self.pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
	else if ([[DIFMStreamer sharedInstance].audioStreamer isIdle])
	{
        [[DIFMStreamer sharedInstance] destroyStreamer];
		[pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	}
}

@end
