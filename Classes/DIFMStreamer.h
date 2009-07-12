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
    AudioStreamer audioStreamer;
    
    // persistent data -- for when stopping/playing
    NSString *currentChannel;
    NSURL *persistentURL;
    double totalSecondsLapsed;
}

@property (nonatomic, retain) AudioStreamer audioStreamer;
@property (nonatomic, retain) NSURL *persistentURL;
@property (copy) NSString *currentChannel;

// methods

+ (DIFMStreamer *) sharedInstance;
- (void) setStreamerURL:(NSString *)theURL;
- (void) stopAndReleaseStreamer;

@end
