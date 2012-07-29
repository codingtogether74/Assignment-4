//
//  MyPhotoViewController.h
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/28/12.
//
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface MyPhotoViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (strong, nonatomic) NSDictionary *photo;
- (void)refreshWithPhoto:(NSDictionary *) photoDictionary;
@end
