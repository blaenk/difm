//
//  ChannelsViewController.h
//  DIFM
//
//  Created by Blaenk on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *genres;
}

@property (nonatomic, retain) NSArray *genres;

@end
