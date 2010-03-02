// ------------------------------------------------------------------------
//  IconLookupTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/11/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "IconLookupTableViewController.h"
#import "EmergencyNumbersModel.h"
#import "UIImage_Resize.h"

@implementation IconLookupTableViewController

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
    return [model.iconsArray count];
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
	cell.textLabel.text = [model.iconsArray objectAtIndex:row];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
	NSString *rowImageName = 
		[NSString stringWithFormat:@"%@Icon.png", 
			[model.iconsArray objectAtIndex:row]];
	
	UIImage *baseImage = [UIImage imageNamed:rowImageName];
	CGImageRef tmp = CGImageCreateWithImageInRect(
		baseImage.CGImage, CGRectMake(46.0f, 10.0f, 64.0, 64.0));
	
	cell.imageView.image = 
		[[UIImage imageWithCGImage:tmp] 
			scaleToSize:CGSizeMake(32.0f, 32.0f)];

	if ([cell.textLabel.text isEqualToString:[[model currentContact] icon]])
	{
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}

	CGImageRelease(tmp);
    return cell;
}


- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	[[model currentContact] setIcon:[model.iconsArray objectAtIndex:row]];
	[model save];
	
	// If pop back on select
	[self.navigationController popViewControllerAnimated:YES];
	
	// If not pop, reload the table
	//[tableView reloadData];
}

@end

