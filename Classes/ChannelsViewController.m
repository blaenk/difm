//
//  ChannelsViewController.m
//  DIFM
//
//  Created by Blaenk on 6/22/09.
//  Copyright 2009 Blaenk Denum. All rights reserved.
//

#import "ChannelsViewController.h"

#import "DIFMAppDelegate.h"
#import "DIFMStreamer.h"

// Sound and Network headers for streaming
#import "AudioStreamer.h"

@implementation ChannelsViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FreeUrls" ofType:@"plist"];
    channels = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    genres = [[channels allKeys] retain];
    
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

//- (void)viewDidUnload {
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:genresTableIdentifier] autorelease];
    }
    
    cell.textLabel.text = selectedGenre;
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    NSString *selectedGenre = [genres objectAtIndex:row];
    
    NSString *streamURL = [channels objectForKey:selectedGenre];

    // don't re-start the stream if it's already playing
    if ([selectedGenre isEqualToString:[DIFMStreamer sharedInstance].currentChannel] &&
        [[DIFMStreamer sharedInstance].audioStreamer isPlaying]) {
        return;
    } else {
        [[DIFMStreamer sharedInstance] destroyStreamer];
        [[DIFMStreamer sharedInstance] resetSeconds];
        [[DIFMStreamer sharedInstance] setStreamerURLWithString:streamURL];
        
        DIFMAppDelegate *delegate = (DIFMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [DIFMStreamer sharedInstance].audioStreamer.delegate = [delegate.tabBarController.viewControllers objectAtIndex:0];
        [DIFMStreamer sharedInstance].audioStreamer.didUpdateMetaDataSelector = @selector(metaDataUpdated:);
        
        [[DIFMStreamer sharedInstance].audioStreamer start];
        
        // set the new channel name
        [DIFMStreamer sharedInstance].currentChannel = selectedGenre;
        
        // change back to the player view
        //delegate.tabBarController.selectedViewController = [[delegate.tabBarController viewControllers] objectAtIndex:0];
    }
}

@end
