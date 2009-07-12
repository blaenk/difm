//
//  DIFMStreamer.m
//  DIFM
//
//  Created by Blaenk on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DIFMStreamer.h"

// Sound and Network headers for streaming
#import "AudioStreamer.h"

@implementation DIFMStreamer

@synthesize audioStreamer;
@synthesize currentChannel;
@synthesize persistentURL;
@synthesize totalSecondsLapsed;

+ (DIFMStreamer *) sharedInstance {
    static DIFMStreamer *gInstance = NULL;
    
    @synchronized(self) {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    
    return gInstance;
}

- (void) setStreamerURL:(NSURL *)streamerURL {
    [self.persistentURL release];
    self.persistentURL = streamerURL;
    
    [self stopAndReleaseStreamer];
    
    // create a new one and start it
    self.audioStreamer = [[AudioStreamer alloc] initWithURL:persistentURL];
}

- (void) setStreamerURLWithString:(NSString *)streamerURL {
    NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)streamerURL,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
    [self.persistentURL release];
	self.persistentURL = [NSURL URLWithString:escapedValue];
    
    [self stopAndReleaseStreamer];
    
    // create a new one and start it
    self.audioStreamer = [[AudioStreamer alloc] initWithURL:persistentURL];
}

- (void) restartStreamerWithPersistentData {
    [self setStreamerURL:self.persistentURL];
    [self.audioStreamer start];
}

- (void) stopAndReleaseStreamer {
    if (self.audioStreamer != nil) {
        // stop and release the old stream
        [self.audioStreamer stop];
        [self.audioStreamer release];
    }
}

- (void) destroyStreamer {
    if (self.audioStreamer)
	{
        [self stopAndReleaseStreamer];
		self.audioStreamer = nil;
	}
}

@end
