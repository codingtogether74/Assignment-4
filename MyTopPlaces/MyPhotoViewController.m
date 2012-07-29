//
//  MyPhotoViewController.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/28/12.
//
//

#import "MyPhotoViewController.h"
#import "FlickrFetcher.h"
#import "RecentsUserDefaults.h"

#define PHOTO_TITLE_KEY  @"title"
#define PHOTO_ID_KEY @"id"
#define TOO_MANY_PHOTOS 20

@interface MyPhotoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation MyPhotoViewController


@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize photo = _photo;

- (NSData*) fetchImage {	
    // Return the image from Flickr
	return [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge]];
}

- (void)synchronizeViewWithImage:(NSData *) imageData
{
	self.imageView.image = [UIImage imageWithData:imageData];
	self.title = [self.photo objectForKey:PHOTO_TITLE_KEY];
	
	// Reset the zoom scale back to 1
	self.scrollView.zoomScale = 1;
    
    self.scrollView.maximumZoomScale = 10.0;
    self.scrollView.minimumZoomScale = 0.1;
    
	self.scrollView.contentSize = self.imageView.image.size;
	self.imageView.frame =
	CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
	
}



- (void)fillView
{
	float wScale = self.view.bounds.size.width / self.imageView.frame.size.width;
	float hScale = self.view.bounds.size.height / self.imageView.frame.size.height;
	self.scrollView.zoomScale = MAX(wScale, hScale);
}

- (void)refresh {
	
		NSString *photoID = [self.photo objectForKey:PHOTO_ID_KEY];
		NSData *imageData = [self fetchImage];
					
			// Only store and display if another photo hasn't been selected
			if ([photoID isEqualToString:[self.photo objectForKey:PHOTO_ID_KEY]]) {
                [RecentsUserDefaults saveRecentsUserDefaults:self.photo];
				[self synchronizeViewWithImage:imageData];
				[self fillView]; // Sets the zoom level to fill screen
			}			
}


- (void)viewDidLoad {
	
	[super viewDidLoad];
	self.scrollView.delegate = self;
	
}

- (void)viewWillAppear:(BOOL)animated {

	if (self.photo) [self refresh];
	
}

- (void)viewWillLayoutSubviews {
    
	// Zoom the image to fill up the view
	if (self.imageView.image) [self fillView];
    
}

- (void)viewDidUnload {
	[self setImageView:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}


@end
