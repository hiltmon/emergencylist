// ------------------------------------------------------------------------
//  ColorLookupTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/9/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ColorLookupTableViewController.h"
#import "EmergencyNumbersModel.h"
#import "UIImage_Resize.h"

@implementation ColorLookupTableViewController

@synthesize model;

#pragma mark -

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods


#pragma mark -
#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [model.colorsArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView 
		dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [model.colorsArray objectAtIndex:row];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
	NSString *rowImageName = 
	[NSString stringWithFormat:@"%@Button.png", 
		[model.colorsArray objectAtIndex:row]];
	cell.imageView.image = 
		[[UIImage imageNamed:rowImageName] 
			scaleToSize:CGSizeMake(32.0f, 32.0f)];
	
	if ([cell.textLabel.text isEqualToString:model.currentContactColor])
	{
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	[model setCurrentContactColor:[model.colorsArray objectAtIndex:row]];
	[model save];
	
	[tableView reloadData];
}

@end

