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
    
    AudioStreamer *streamer; // the streamer that any view can retrieve
    NSString *currentChannel; // the currently playing channel
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) NSString *currentChannel;

@end

