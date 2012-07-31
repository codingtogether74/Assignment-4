//
//  RecentsUserDefaults.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentsUserDefaults.h"
#import "FlickrFetcher.h"

@implementation RecentsUserDefaults
+(NSArray *)retrieveRecentsUserDefaults
{
    NSUserDefaults *recentsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *photos;
    photos = [recentsUserDefaults arrayForKey:@"Recents Viewed Photos"];
    return photos;
}

+(void)saveRecentsUserDefaults:(NSDictionary *)photo
{
    NSUserDefaults *recentsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *photosMutalbeCopy = [[recentsUserDefaults arrayForKey:@"Recents Viewed Photos"] mutableCopy];
    if (!photosMutalbeCopy) {
        photosMutalbeCopy = [NSMutableArray array];
    }
    //to avoid duplex photo copy
    NSString *newPhotoID = [photo valueForKey:FLICKR_PHOTO_ID];
    for (int i=0; i<[photosMutalbeCopy count]; i++) {
        NSString *oldPhotoID = [[photosMutalbeCopy objectAtIndex:i] valueForKey:FLICKR_PHOTO_ID];
        if ([newPhotoID isEqualToString:oldPhotoID]) [photosMutalbeCopy removeObjectAtIndex:i];
    }
    [photosMutalbeCopy insertObject:photo atIndex:0];
    
    //if (![photosMutalbeCopy containsObject:photo]) { //this code work fine but better check photo id
    //    [photosMutalbeCopy insertObject:photo atIndex:0];
    //}
    
    NSArray *photos = [photosMutalbeCopy copy];
    if ([photos count]>RECENTS_PHOTO_AMOUNT) {
        NSRange range;
        range.location = 0;
        range.length = RECENTS_PHOTO_AMOUNT;
        photos = [photos subarrayWithRange:range];
    }
    [recentsUserDefaults setValue:photos forKey:@"Recents Viewed Photos"];
    [recentsUserDefaults synchronize];
}
@end
