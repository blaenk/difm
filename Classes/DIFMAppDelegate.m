//
//  DIFMAppDelegate.m
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright Blaenk Denum 2009. All rights reserved.
//

#import "DIFMAppDelegate.h"
#import "PlayerViewController.h"

// Sound and Network headers for streaming
#import "AudioStreamer.h"

@implementation DIFMAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize streamer;
@synthesize currentChannel;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Override point for customization after application launch
    [window addSubview:self.tabBarController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end
