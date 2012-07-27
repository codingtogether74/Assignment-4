//
//  TopPlacesTableViewController.m
//  MyTopPlaces
//
//  Created by Olga Avanesova on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosInPlacesTableViewController.h"
@interface TopPlacesTableViewController ()

@end

@implementation TopPlacesTableViewController
@synthesize topPlaces=_topPlaces;

-(void)setTopPlaces:(NSArray *)topPlaces
{
    if(_topPlaces!=topPlaces){
        _topPlaces=topPlaces;
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
    NSArray *topPlaces = [FlickrFetcher topPlaces];
    self.topPlaces = topPlaces;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return YES;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Top Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *topPlace = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *placeFullName = [topPlace objectForKey:FLICKR_PLACE_NAME];
    NSArray *placeArray = [placeFullName componentsSeparatedByString:@", "];
    NSString *placeCityName = [placeArray objectAtIndex:0];
    NSString *placeRestName = [NSString stringWithFormat:@"%@, %@",[placeArray objectAtIndex:1],[placeArray objectAtIndex:2]];
    cell.textLabel.text = placeCityName;
    cell.detailTextLabel.text = placeRestName;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *place = [self.topPlaces objectAtIndex:path.row];
 
    [segue.destinationViewController setPlace:place];
    [segue.destinationViewController setTitle:[[sender textLabel] text]];			

}

@end
