// ------------------------------------------------------------------------
//  ItemTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/8/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ItemTableViewController.h"
#import "EmergencyNumbersModel.h"
//#import "TwoColumnTableViewCell.h"
#import "ButtonLookupTableViewController.h"

@implementation ItemTableViewController

@synthesize model;

#pragma mark -

- (void)dealloc
{
    [super dealloc];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

#pragma mark -
#pragma mark Action Methods


#pragma mark -
#pragma mark UIViewController

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    switch (section)
	{
		case NameSection:		return 2;
		// TODO: 3 when add icon
		case ButtonSection:		return 2;
	}
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case NameSection:  return @"Emergency Contact";
        case ButtonSection: return @"Quick Button";
    }
    
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

	// Reusing the same twocloumn cell, so I can safely assume the dequeue
	// gives me the right object type.
    UITableViewCell *cell = 
		(UITableViewCell*)[tableView 
			dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleValue1 
				 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	switch (section)
	{
		case NameSection:
			if (row == 0)
			{
				cell.textLabel.text = @"Name";
				cell.detailTextLabel.text = model.currentContactName;
			}
			else
			{
				cell.textLabel.text = @"Number";
				cell.detailTextLabel.text = model.currentContactNumber;
			}

			break;
			
		case ButtonSection:
			if (row == 0)
			{
				cell.textLabel.text = @"Button";
				cell.detailTextLabel.text = model.currentContactButton;
			}
			else if (row == 1)
			{
				cell.textLabel.text = @"Color";
				cell.detailTextLabel.text = model.currentContactColor;
			}
			
			break;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	switch (section)
	{
		case NameSection:
			break;
			
		case ButtonSection:
			if (row == 0)
			{
				ButtonLookupTableViewController *buttonLookupController = 
					[[ButtonLookupTableViewController alloc]
						initWithNibName:@"ButtonLookupView" bundle:nil];
				[buttonLookupController setModel:model];
				[self.navigationController 
					pushViewController:buttonLookupController animated:YES];
				[buttonLookupController release];
			}
			break;
	}
	
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end

