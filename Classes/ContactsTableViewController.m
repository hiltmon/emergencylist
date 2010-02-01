// ------------------------------------------------------------------------
//  ContactsTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ContactsTableViewController.h"
#import "ContactsDetailViewController.h"
#import "EmergencyNumbersAppDelegate.h"	// Needed to get to the nav controller

@implementation ContactsTableViewController

@synthesize contactsArray;
@synthesize contactsDetailViewController;

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller
	// programmatically and want to perform customization that
	// is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style])
	{
    
	}
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Contacts", @"My Emergency Contacts");
	
	//NSMutableArray *array = [[NSArray alloc] 
	//		initWithObjects:@"Contact 1", @"Contact 2", @"Contact 3", nil];
	//self.contactsArray = array;
	//[array release];
	
	EmergencyNumbersAppDelegate *appDelegate = 
		(EmergencyNumbersAppDelegate *)
			[[UIApplication sharedApplication] delegate];
	self.contactsArray = appDelegate.model.contactsArray;

    // Uncomment the following line to display an Edit button 
	// in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:
	(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [self.contactsArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] 
					autorelease];
    }
    
    // Set up the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [[contactsArray objectAtIndex:row] 
						   valueForKey:@"name"];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = 
	//     [[AnotherViewController alloc] 
	//		   initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	NSUInteger row = [indexPath	row];
	if (self.contactsDetailViewController == nil)
	{
		ContactsDetailViewController *aContactsDetail = 
			[[ContactsDetailViewController alloc]
				initWithNibName:@"ContactsDetailView" bundle:nil];
		self.contactsDetailViewController = aContactsDetail;
		[aContactsDetail release];
	}
	
	contactsDetailViewController.title =
		[NSString stringWithFormat:@"%@", 
			[[contactsArray objectAtIndex:row] valueForKey:@"name"]];
	
	// Get to the navigation bar by findin the application delegate
	EmergencyNumbersAppDelegate *appDelegate = 
		(EmergencyNumbersAppDelegate *)
			[[UIApplication sharedApplication] delegate];
	[appDelegate.contactsNavController 
		pushViewController:contactsDetailViewController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView 
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath
{  
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:
			[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        // Create a new instance of the appropriate class, insert it
		// into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView 
 canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)dealloc
{
	[contactsDetailViewController release];
    [super dealloc];
}

@end

