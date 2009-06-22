//
//  DIFMAppDelegate.h
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;
@class PlayerViewController;

@interface DIFMAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    
    PlayerViewController *playerView; // access the player view to set it as the delegate for the streamer
    
    AudioStreamer *streamer; // the streamer that any view can retrieve
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet PlayerViewController *playerView;
@property (nonatomic, retain) AudioStreamer *streamer;

@end

