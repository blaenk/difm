//
//  ChannelsViewController.h
//  DIFM
//
//  Created by Blaenk on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *channels;
    NSArray *genres;
}

@property (nonatomic, retain) NSDictionary *channels;
@property (nonatomic, retain) NSArray *genres;

@end
