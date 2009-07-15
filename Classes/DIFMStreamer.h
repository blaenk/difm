//
//  DIFMStreamer.h
//  DIFM
//
//  Created by Blaenk on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioStreamer;

@interface DIFMStreamer : NSObject {
    AudioStreamer *audioStreamer;
    
    // persistent data -- for when stopping/playing
    NSString *currentChannel;
    NSURL *persistentURL;
    
    // time specific
    int totalSecondsLapsed;
    int hours;
    int minutes;
    int seconds;
}

@property (nonatomic, retain) AudioStreamer *audioStreamer;
@property (copy) NSString *currentChannel;
@property (nonatomic, retain) NSURL *persistentURL;

// methods

+ (DIFMStreamer *) sharedInstance;
- (void) setStreamerURL:(NSURL *)streamURL;
- (void) setStreamerURLWithString:(NSString *)streamURL;
- (void) stopAndReleaseStreamer;
- (void) restartStreamerWithPersistentData;
- (void) destroyStreamer;

- (void) tickSeconds;
- (void) resetSeconds;
- (NSMutableString *) formattedTimeString;

@end
