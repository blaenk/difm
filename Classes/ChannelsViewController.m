//
//  ChannelsViewController.m
//  DIFM
//
//  Created by Blaenk on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ChannelsViewController.h"

#import "DIFMAppDelegate.h"

// Sound and Network headers for streaming
#import "AudioStreamer.h"

@implementation ChannelsViewController

@synthesize channels;
@synthesize genres;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FreeUrls" ofType:@"plist"];
    channels = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    genres = [[channels allKeys] retain];
    
    // point to appdelegate's streamer
//    DIFMAppDelegate *delegate = (DIFMAppDelegate *)[[UIApplication sharedApplication] delegate];
//    streamer = [delegate streamer];
    
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [channels release];
    [genres release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [genres count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedGenre = [genres objectAtIndex:[indexPath row]];
    
    static NSString *genresTableIdentifier = @"GenresTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:genresTableIdentifier];
    
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:genresTableIdentifier] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:genresTableIdentifier] autorelease];
    }
    
    //cell.textLabel.text = [channels objectAtIndex:row];
    cell.textLabel.text = selectedGenre;
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DIFMAppDelegate *delegate = (DIFMAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUInteger row = [indexPath row];
    
    NSString *selectedGenre = [genres objectAtIndex:row];
    
    NSString *streamURL = [channels objectForKey:selectedGenre];

    // set the new streamURL here
    NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)streamURL,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
	NSURL *url = [NSURL URLWithString:escapedValue];
    
    // stop and release the old stream
    [delegate.streamer stop];
    NSLog(@"NSURL: %@", url);
    [delegate.streamer release];
    
    // create a new one and start it
    delegate.streamer = [[AudioStreamer alloc] initWithURL:url];
    [delegate.streamer setDelegate:[[delegate.tabBarController viewControllers] objectAtIndex:0]];
    [delegate.streamer setDidUpdateMetaDataSelector:@selector(metaDataUpdated:)];
    NSLog(@"Streamer URL: %@", delegate.streamer.url);
    [delegate.streamer start];
    // set the new channel name
    delegate.currentChannel = selectedGenre;
    
    // change back to the player view
    //delegate.tabBarController.selectedViewController = [[delegate.tabBarController viewControllers] objectAtIndex:0];
}

@end
