//
//  PlayerViewController.h
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// -todo: create git repos of DIFM dir
// -add the channels table view
// -store the channels info in xml or plist
// -store time in sqlite3 db
// -create a nice aura effect to di.fm logo
// -add landscape view

// -for the channels table view, after a click on a stream, use selectedViewController on the tabBarController
// -store the AudioStreamer on the appdelegate so that others can use it

// have the users download the pls file then save the url(s) to the plist?

@class DIFMAppDelegate;

@interface PlayerViewController : UIViewController {
    // Labels
    UILabel *playTime; // the duration
    NSTimer *progressUpdateTimer; // timer for playTime
    UILabel *streamInfo; // channel + bitrate
    
    UILabel *nowPlayingArtist;
    UILabel *nowPlayingSong;
    
    // Button
    UIButton *pauseButton;
    
    // Internals
    BOOL isPlaying;
    
    // Time - this isn't needed, yet
    int seconds;
    int minutes;
    int hours;
    
    NSMutableString *formattedTimeString;
    
    DIFMAppDelegate *delegate;
    
    NSURL *persistentURL;
    int persistentTimeInSeconds;
}

@property (nonatomic, retain) IBOutlet UILabel *playTime;
@property (nonatomic, retain) IBOutlet UILabel *streamInfo;

@property (nonatomic, retain) IBOutlet UILabel *nowPlayingArtist;
@property (nonatomic, retain) IBOutlet UILabel *nowPlayingSong;

@property (nonatomic, retain) IBOutlet UIButton *pauseButton;

- (void)pauseToggle:(id)sender;

- (void)destroyStreamer;
- (void)updateProgress:(NSTimer *)aNotification;
- (void)metaDataUpdated:(NSString *)metaData;

@end
