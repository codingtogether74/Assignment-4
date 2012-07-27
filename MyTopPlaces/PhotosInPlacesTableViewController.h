//
//  PhotosInPlacesTableViewController.h
//  MyTopPlaces
//
//  Created by Olga Avanesova on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosInPlacesTableViewController : UITableViewController
@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSArray *photos;
@end
