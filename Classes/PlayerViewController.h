//
//  PlayerViewController.h
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright 2009 Blaenk Denum. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DIFMAppDelegate;

@interface PlayerViewController : UIViewController {
    // Labels
    UILabel *playTime; // the duration
    UILabel *streamInfo; // channel + bitrate
    
    UILabel *nowPlayingArtist;
    UILabel *nowPlayingSong;
    
    // Button
    UIButton *pauseButton;
    
    // Volume View
    UIView *volumeView;
    
    // Internals
    BOOL isPlaying;
    
    // Time - this isn't needed, yet
    int seconds;
    int minutes;
    int hours;
    
    NSTimer *progressUpdateTimer; // timer for playTime
    NSMutableString *formattedTimeString; // to present the time
}

// presentational
@property (nonatomic, retain) IBOutlet UILabel *playTime;
@property (nonatomic, retain) IBOutlet UILabel *streamInfo;

@property (nonatomic, retain) IBOutlet UILabel *nowPlayingArtist;
@property (nonatomic, retain) IBOutlet UILabel *nowPlayingSong;

@property (nonatomic, retain) IBOutlet UIView *volumeView;

// actions
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;

// action handler
- (void)pauseToggle:(id)sender;

// stream specific
- (void)updateProgress:(NSTimer *)aNotification;
- (void)metaDataUpdated:(NSString *)metaData;
- (void)playbackStateChanged:(NSNotification *)aNotification;

@end
