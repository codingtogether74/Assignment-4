//
//  PhotosInPlacesTableViewController.h
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosInPlacesTableViewController : UITableViewController
@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSMutableArray *photos;
@end
