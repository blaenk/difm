//
//  DIFMAppDelegate.m
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "DIFMAppDelegate.h"
#import "PlayerViewController.h"

// Sound and Network headers for streaming
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@implementation DIFMAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize streamer;
@synthesize playerView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Override point for customization after application launch
    [streamer setDelegate:playerView];
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end
