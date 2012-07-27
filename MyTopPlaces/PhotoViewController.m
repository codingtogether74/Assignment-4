//
//  PhotoViewController.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation PhotoViewController
@synthesize photoView;
@synthesize scrollView;
@synthesize photo=_photo;

-(void)viewDidLoad
{
    [super viewDidLoad];

    //load the image from url
    NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    self.photoView.image = image;
    
    // setup zooming
    self.scrollView.delegate=self;
    
// setup scroll
    self.scrollView.contentSize=self.photoView.image.size;
    self.photoView.frame=CGRectMake(0, 0, self.photoView.image.size.width, self.photoView.image.size.height);
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoView;  
}

- (void)fillView {
	
    ///set default zoomScale to fit the screen
    //in the storyboard, select the scrollview,choose the attributes inspector,"Autoresize Subviews", disabled it
    CGFloat defaultZoomScaleX = (self.view.frame.size.width-self.scrollView.frame.origin.x)/photoView.image.size.width;
    CGFloat defaultZoomScaleY = (self.view.frame.size.height-self.scrollView.frame.origin.y)/photoView.image.size.height;
    self.scrollView.zoomScale = MAX(defaultZoomScaleX, defaultZoomScaleY);
/*    /-----------------
	// Width ratio compares the width of the viewing area with the width of the image	
	float widthRatio = self.view.bounds.size.width / self.photoView.image.size.width;
	
	// Height ratio compares the height of the viewing area with the height of the image	
	float heightRatio = self.view.bounds.size.height / self.photoView.image.size.height; 
	
	// Update the zoom scale
      [self.scrollView setZoomScale:MAX(widthRatio, heightRatio) animated:YES];
*/	
}

- (void)viewWillLayoutSubviews { 
    
	// Zoom the image to fill up the view
	if (self.photoView.image) [self fillView];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return YES;
    
}

- (void)viewDidUnload {
    [self setPhotoView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
