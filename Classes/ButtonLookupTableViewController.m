// ------------------------------------------------------------------------
//  ButtonLookupTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/9/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ButtonLookupTableViewController.h"
#import "EmergencyNumbersModel.h"

@implementation ButtonLookupTableViewController

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
    return [model.buttonsArray count];
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
	
	EmergencyContact *theContact = [model contactForButton:row];

	cell.textLabel.text = theContact.name;
	cell.textLabel.textColor = [UIColor blackColor];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
	if (cell.textLabel.text == nil)
	{
		cell.textLabel.text = [model.buttonsArray objectAtIndex:row];
		cell.textLabel.textColor = [UIColor lightGrayColor];
	}
	
	NSString *rowImageName = 
		[NSString stringWithFormat:@"WhichButton%d.png", row];
	cell.imageView.image = 
		[UIImage imageNamed:rowImageName] ;
	
	//if ((theContact != nil) && ([theContact.button intValue] == row))
	//{
	//	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	//}
	
    return cell;
}

#pragma mark -
#pragma mark UITableViewDataSource Protocol

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSString *whichButton = [NSString stringWithFormat:@"%d", row];
	[model clearButton:whichButton];
	[[model currentContact] setButton:whichButton];
	[model save];
	
	[tableView reloadData];
}

@end

