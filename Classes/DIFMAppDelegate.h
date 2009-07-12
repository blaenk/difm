//
//  DIFMAppDelegate.h
//  DIFM
//
//  Created by Blaenk on 6/20/09.
//  Copyright Blaenk Denum 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;
@class PlayerViewController;

@interface DIFMAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

