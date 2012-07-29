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

@property (nonatomic, strong) NSDictionary *placesByCountry;
@property (nonatomic, strong) NSArray *countries;
@property (strong, nonatomic) NSArray *sectionHeaders;
@end

@implementation TopPlacesTableViewController
@synthesize topPlaces=_topPlaces;
@synthesize placesByCountry=_placesByCountry;
@synthesize countries=_countries;
@synthesize sectionHeaders=_sectionHeaders;

#define CONTENT_KEY @"_content"

- (NSString *)parseForCountry: (NSDictionary *) topPlace {
    NSString *placeInformation = [topPlace objectForKey:CONTENT_KEY];
	
	// Search the place information for the last comma.
	NSRange lastComma = [placeInformation rangeOfString:@"," options:NSBackwardsSearch];
	if (lastComma.location != NSNotFound) {
		return [placeInformation substringFromIndex:lastComma.location + 2];
	} else return @"";		
}

- (void)loadTopPlaces {
	
	if (self.topPlaces) return;
    
	// Create a sorted array of place descriptions
	NSArray *sortDescriptors = [NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:CONTENT_KEY
                                                              ascending:YES]];
    
    
	// Set up the array of top places, organised by place descriptions
	self.topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:sortDescriptors];
	
	// We want to divide the places up by country, so we can use a dictionary with the
	// country names as key and the places as values
	NSMutableDictionary *placesByCountry = [NSMutableDictionary dictionary];
    
	// For each place
	for (NSDictionary *place in self.topPlaces) {
		// extract the country name
		NSString *country = [self parseForCountry:place];
		// If the country isn't already in the dictionary, add it with a new array
		if (![placesByCountry objectForKey:country]) {
			[placesByCountry setObject:[NSMutableArray array] forKey:country];
		}
		// Add the place to the countries' value array
		[(NSMutableArray *)[placesByCountry objectForKey:country] addObject:place];
	}
    
	// Set the place by country
	self.placesByCountry = [NSDictionary dictionaryWithDictionary:placesByCountry];
    
	// Set up the section headers in alphabetical order
	self.sectionHeaders = [[placesByCountry allKeys] sortedArrayUsingSelector:
                           @selector(caseInsensitiveCompare:)];
    
}

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
//    NSArray *topPlaces = [FlickrFetcher topPlaces];
//    self.topPlaces = topPlaces;
    [self loadTopPlaces];

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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	// Return the number of sections
	return self.sectionHeaders.count;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// Return the header at the given index
	return [self.sectionHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows for the given the section
	return [[self.placesByCountry objectForKey:
             [self.sectionHeaders objectAtIndex:section]] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
/*-----------Not by country--------------------------------------------------
    static NSString *CellIdentifier = @"Top Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *topPlace = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *placeFullName = [topPlace objectForKey:FLICKR_PLACE_NAME];
    NSArray *placeArray = [placeFullName componentsSeparatedByString:@", "];
    NSString *placeCityName = [placeArray objectAtIndex:0];
    NSString *placeRestName;
    if ([placeArray count]<=2) {
        placeRestName = [NSString stringWithFormat:@"%@",[placeArray objectAtIndex:1]];
    } else{
        placeRestName = [NSString stringWithFormat:@"%@, %@",[placeArray objectAtIndex:1],[placeArray objectAtIndex:2]];
    }
    cell.textLabel.text = placeCityName;
    cell.detailTextLabel.text = placeRestName;
    return cell;
*/
    static NSString *CellIdentifier = @"Top Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
	// Get a handle the dictionary that contains the selected top place information
	NSDictionary *topPlaceDictionary =
	[[self.placesByCountry objectForKey:[self.sectionHeaders objectAtIndex:indexPath.section]]
	 objectAtIndex:indexPath.row];
    
	// Extract the place name information for the cell
	NSString *topPlaceDescription = [topPlaceDictionary objectForKey:CONTENT_KEY];
	
	// Format the top place description into the cell's title and subtitle
	// Check to see if place description has a comma
	NSRange firstComma = [topPlaceDescription rangeOfString:@","];
	
	// If no comma, then title is place description and we have no subtitle, otherwise set the
	// title to everything before the comma and the subtitle to everything after it.
	if (firstComma.location == NSNotFound) {
		cell.textLabel.text = topPlaceDescription;
		cell.detailTextLabel.text = @"";
	} else {
		cell.textLabel.text = [topPlaceDescription substringToIndex:firstComma.location];
		cell.detailTextLabel.text = [topPlaceDescription substringFromIndex:
                                     firstComma.location + 1];
	}	
    return cell;	 

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	int section = self.tableView.indexPathForSelectedRow.section;
	int row = self.tableView.indexPathForSelectedRow.row;
	// Identify the selected place from within the places by country dictionary
	NSDictionary *placeDictionary =
    [[self.placesByCountry valueForKey:
     [self.sectionHeaders objectAtIndex:section]] objectAtIndex:row];
	
	[self.topPlaces objectAtIndex:self.tableView.indexPathForSelectedRow.row];

    // Set up the photo descriptions in the PhotoDescriptionViewController
    [[segue destinationViewController] setPlace:placeDictionary ];
    [segue.destinationViewController setTitle:[[sender textLabel] text]];
/*-------------------Not by country------------------------------
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *place = [self.topPlaces objectAtIndex:path.row];
 
    [segue.destinationViewController setPlace:place];
    [segue.destinationViewController setTitle:[[sender textLabel] text]];			
*/
}

@end
