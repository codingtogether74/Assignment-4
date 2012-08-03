//
//  TopPlacesPhotoViewController.m
//   MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/28/12.
//

#import "TopPlacesPhotoViewController.h"
#import "FlickrFetcher.h"
#import "RecentsUserDefaults.h"

#define PHOTO_TITLE_KEY  @"title"
#define PHOTO_ID_KEY @"id"
#define TOO_MANY_PHOTOS 20

@interface TopPlacesPhotoViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSString *photoTitle;

@end

@implementation TopPlacesPhotoViewController
 
@synthesize photoScrollView = _photoScrollView;
@synthesize photoImageView = _photoImageView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize photoTitle = _photoTitle;

@synthesize photo = _photo;

- (void)synchronizeViewWithImage:(NSData *) imageData
{
	self.photoImageView.image = [UIImage imageWithData:imageData];
	self.title = [self.photo objectForKey:PHOTO_TITLE_KEY];
	
	// Reset the zoom scale back to 1
	self.photoScrollView.zoomScale = 1;
    
    self.photoScrollView.maximumZoomScale = 10.0;
    self.photoScrollView.minimumZoomScale = 0.1;
    
	self.photoScrollView.contentSize = self.photoImageView.image.size;
	self.photoImageView.frame =
	CGRectMake(0, 0, self.photoImageView.image.size.width, self.photoImageView.image.size.height);
	
}
#pragma mark - Scroll View Delegate

// set the image that needs to be scrolled by the scrollview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}

- (void)setPhotoTitle:(NSString *)photoTitle
{
    if ([photoTitle isEqualToString:@""])
        _photoTitle = @"no photo description";
    else
        _photoTitle = photoTitle;
    
    // title for the iPad
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
//    NSLog(@"%i", [toolbarItems count]);
    // assume we use the button before the last
    UIBarButtonItem *titleButton = [toolbarItems objectAtIndex:[toolbarItems count]-2];
    titleButton.title = _photoTitle;
    // title for the iPhone
  self.title = _photoTitle;
}
   
- (void)fillView
{
	float wScale = self.view.bounds.size.width / self.photoImageView.frame.size.width;
	float hScale = self.view.bounds.size.height / self.photoImageView.frame.size.height;
	self.photoScrollView.zoomScale = MAX(wScale, hScale);
    [self.photoImageView setNeedsDisplay];
}

- (void)loadPhoto {
    if (self.photo) {
        NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData *photoData = [[NSData alloc] initWithContentsOfURL:photoURL];
        if (photoData) {
            NSString *photoID = [self.photo objectForKey:PHOTO_ID_KEY];
			// Only store and display if another photo hasn't been selected
			if ([photoID isEqualToString:[self.photo objectForKey:PHOTO_ID_KEY]]) {
                [RecentsUserDefaults saveRecentsUserDefaults:self.photo];
				[self synchronizeViewWithImage:photoData];
				[self fillView]; // Sets the zoom level to fill screen
			}
            // Assignment 4 - task 7
            self.photoTitle = [self.photo valueForKey:FLICKR_PHOTO_TITLE];
        } else {
            self.photoTitle = @"no photo retrieved";
        }
    } else {
        self.photoTitle = @"no photo selected";
    }
}

//  This one was added for the iPad splitview
//  It needs displaying the image again if the photo is changed
- (void)setPhoto:(NSDictionary *)photo {
    if (photo != _photo) {
        _photo = photo;
        [self loadPhoto];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // instruction from lecture 8
    self.photoScrollView.delegate = self;
    // get the actual photo now that the view is loading
//    [self loadPhoto];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
	if (self.photo) [self loadPhoto];
	
}

- (void)viewWillLayoutSubviews {
    
	// Zoom the image to fill up the view
	if (self.photoImageView.image) [self fillView];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setPhotoScrollView:nil];
    [self setToolbar:nil];
    [self setPhotoScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - Split View Controller

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) {
            [toolbarItems removeObject:_splitViewBarButtonItem];
        }
        if (splitViewBarButtonItem) {
            [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        }
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

@end
