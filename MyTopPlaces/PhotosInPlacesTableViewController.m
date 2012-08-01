//
//  PhotosInPlacesTableViewController.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosInPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPlacesPhotoViewController.h"
#import "RecentsUserDefaults.h"

@interface PhotosInPlacesTableViewController ()

@end

@implementation PhotosInPlacesTableViewController
@synthesize place=_place;
@synthesize photos=_photos;

-(void)setPhotos:(NSArray *)photos
{
    if (_photos!=photos) {
        _photos=photos;
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:50];
    self.photos = photos;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Photos Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *photoTitle = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if ([photoTitle length]==0 && [photoDescription length]!=0) {
        photoTitle = photoDescription;
        photoDescription = nil;
    }
    if ([photoTitle length]==0 && [photoDescription length]==0) {
        photoTitle = @"Unknown";
    }
    cell.textLabel.text = photoTitle;
    cell.detailTextLabel.text = photoDescription;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *photo = [self.photos objectAtIndex:path.row];
    [segue.destinationViewController setPhoto:photo];
    [segue.destinationViewController setTitle:[[sender textLabel] text]];
//    [RecentsUserDefaults saveRecentsUserDefaults:photo];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *photo = [self.photos objectAtIndex:path.row];
	// Get a handle to the detail view controller
    
	TopPlacesPhotoViewController *photoViewController =
    [[self.splitViewController viewControllers] lastObject];
	
	if (photoViewController) {
		// Set up the photoViewController model and synchronize it's views
		[photoViewController setPhoto:photo];
	} // otherwise handled by the segue
	
}



@end
