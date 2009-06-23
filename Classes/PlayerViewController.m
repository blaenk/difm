//
//  PlayerViewController.m
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "DIFMAppDelegate.h"

// Sound and Network headers for streaming
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@implementation PlayerViewController

@synthesize playTime;
@synthesize streamInfo;

@synthesize nowPlayingArtist;
@synthesize nowPlayingSong;

@synthesize pauseButton;

- (void)pauseToggle:(id)sender {
    if (![streamer isPlaying]) {
        // play the stream
        
        [self createStreamer];
        
        // loading?
        [pauseButton setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
        
        [streamer start];
        isPlaying = TRUE;
    } else {
        // pause the stream
        [streamer stop];
        
        // save the stream progress
        
        // erase the labels
        streamInfo.text = @"Nothing Playing";
        nowPlayingArtist.text = @"";
        nowPlayingSong.text = @"";
        
        isPlaying = FALSE;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    formattedTimeString = [[NSMutableString alloc] initWithCapacity:8]; // 12:12:12
    
    DIFMAppDelegate *delegate = (DIFMAppDelegate *)[[UIApplication sharedApplication] delegate];
    streamer = [delegate streamer];
    
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
    [self destroyStreamer];
    [playTime release];
    [streamInfo release];
    
    [nowPlayingArtist release];
    [nowPlayingSong release];
    
    [pauseButton release];
    
    [formattedTimeString release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Streamer

- (void)createStreamer {
	if (streamer)
		return;
    
	[self destroyStreamer];
	
	NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)@"http://72.26.204.32:80/trance_hi?8548ef3ddf5544f",
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
    
    [streamer setDelegate:self];
    [streamer setDidUpdateMetaDataSelector:@selector(metaDataUpdated:)];
}

- (void)metaDataUpdated:(NSString *)metaData {
    NSString *temp = [metaData stringByReplacingOccurrencesOfString:@"StreamTitle='" withString:@""];
    NSString *temp2 = [temp stringByReplacingOccurrencesOfString:@"';StreamUrl='';" withString:@""];
    
    NSArray *stringParts = [temp2 componentsSeparatedByString:@" - "];
    
    nowPlayingArtist.text = [stringParts objectAtIndex:0];
    nowPlayingSong.text = [stringParts objectAtIndex:1];
}

- (void)updateProgress:(NSTimer *)updatedTimer {
    int totalSeconds = (int)streamer.progress;
    
    [formattedTimeString setString:@""];
    
    hours = totalSeconds / (60 * 60);
    
    if (hours > 0)
        [formattedTimeString appendFormat:@"%02d:", hours];
    
    minutes = (totalSeconds / 60) % 60;
    seconds = totalSeconds % 60;
    
    [formattedTimeString appendFormat:@"%02d:%02d", minutes, seconds];
    
    if (streamer.bitRate != 0.0) {
		playTime.text = formattedTimeString;
        
        // set stream/channel info
        streamInfo.text = [NSString stringWithFormat:@"%@ Channel - %dkbps", @"Trance", (streamer.bitRate / 1000)];
	} else {
		playTime.text = formattedTimeString;
        
        streamInfo.text = @"Nothing Playing";
	}
}

- (void)destroyStreamer {
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification {
	if ([streamer isWaiting])
	{
        [pauseButton setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
	}
	else if ([streamer isPlaying])
	{
        [pauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	}
}

@end
