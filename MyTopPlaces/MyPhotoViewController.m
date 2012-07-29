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

@interface MyPhotoViewController ()<UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation MyPhotoViewController


@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize toolBarButton = _toolBarButton;
@synthesize toolBar = _toolBar;
@synthesize photo = _photo;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self; //if put in viewDidLoad, delegate will be too late to assign, no button first launch
}
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

- (void)refreshWithPhoto:(NSDictionary *)photoDictionary {
	
	// Setup the model
	self.photo = photoDictionary;
	
	// Refresh the view
	[self refresh];
	
}

- (void)refresh {
	
//    NSString *title ;
//    if (self.photo) title = [self.photo objectForKey:FLICKR_PHOTO_TITLE];
//    self.navigationItem.title = title;
//    self.toolBarButton.title = title;

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
	// Set this instance as the split view delegate
//	self.splitViewController.delegate = self;
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
	
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
    [self setToolBar:nil];
    [self setToolBarButton:nil];
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}

#pragma mark - Split View Controller

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolBar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem)
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter {
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) detailVC = nil;
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    // add button to toolbar
    barButtonItem.title = @"Place";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem =barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}
@end
