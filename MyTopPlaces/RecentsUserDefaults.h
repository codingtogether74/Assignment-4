//
//  RecentsUserDefaults.h
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RECENTS_PHOTO_AMOUNT 20

@interface RecentsUserDefaults : NSObject

+(NSArray *)retrieveRecentsUserDefaults;

+(void)saveRecentsUserDefaults:(NSDictionary *)photo;

@end
