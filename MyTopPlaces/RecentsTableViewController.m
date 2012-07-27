//
//  RecentsTableViewController.m
//  MyTopPlaces
//
//  Created by Olga Avanesova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "RecentsUserDefaults.h"

@implementation RecentsTableViewController

- (void) viewWillAppear:(BOOL)animated {
	// Hide the navigation bar for view controllers when this view appears
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];
      self.photos = [RecentsUserDefaults retrieveRecentsUserDefaults]; //if put in viewDidLoad, it only get called once after launching app
}

- (void) viewWillDisappear:(BOOL)animated {
	// Show the navigation bar for view controllers when this view disappears
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillDisappear:animated];
}
@end
