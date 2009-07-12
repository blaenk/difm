//
//  DIFMStreamer.m
//  DIFM
//
//  Created by Blaenk on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DIFMStreamer.h"

@implementation DIFMStreamer

@synthesize currentChannel;

+ (DIFMStreamer *) sharedInstance {
    static DIFMStreamer *gInstance = NULL;
    
    @synchronized(self) {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    
    return gInstance;
}

- (void) setStreamerURL:(NSString *)streamerURL {
    NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)streamerURL,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
    [persistentURL release];
	persistentURL = [NSURL URLWithString:escapedValue];
    
    if (self.audioStreamer != nil) {
        // stop and release the old stream
        [self.audioStreamer stop];
        [self.audioStreamer release];
    }
    
    // create a new one and start it
    self.audioStreamer = [[AudioStreamer alloc] initWithURL:url];
}

- (void) stopAndReleaseStreamer {
    // persistent data
    self.totalSecondsLapsed = self.streamer.progress;
    
    [self.streamer stop];
    [self.streamer release];
}

- (void) destroyStreamer {
    if (self.streamer)
	{
        [self stopAndReleaseStreamer];
		self.streamer = nil;
	}
}

@end
