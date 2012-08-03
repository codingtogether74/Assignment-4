//
//  RecentsTableViewController.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "RecentsUserDefaults.h"

@implementation RecentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
	// Hide the navigation bar for view controllers when this view appears
//	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];
      self.photos = [[RecentsUserDefaults retrieveRecentsUserDefaults] mutableCopy]; //if put in viewDidLoad, it only get called once after launching app
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
	// Show the navigation bar for view controllers when this view disappears
//	[self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillDisappear:animated];
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove item from list
        [self.photos removeObjectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //write to user defaults
        [defaults setObject:self.photos forKey:@"Recents Viewed Photos"];
        [defaults synchronize];
        
        // Delete the row from the data source (i.e. table)
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
