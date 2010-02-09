// ------------------------------------------------------------------------
//  ContactsTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ContactsTableViewController.h"
//#import "ContactsDetailViewController.h"
#import "ItemTableViewController.h"
#import "EmergencyNumbersAppDelegate.h"	// Needed to get to model
#import "EmergencyNumbersModel.h"

@implementation ContactsTableViewController

#pragma mark -

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods

- (void)addNew
{
	[model addObject:@""];
	[model setCurrentContactIndex:[model count]-1];
	
	ContactsDetailViewController *addController = 
		[[ContactsDetailViewController alloc]
			initWithNibName:@"ContactsDetailView" bundle:nil];
	addController.delegate = self;
	
	addController.title = kNewItem;
	//self.title = NSLocalizedString(@"Emergency List", @"Emergency List Header");
	[addController setModel:model];
	
	UINavigationController *addNavController = 
		[[UINavigationController alloc]
			initWithRootViewController:addController];
	
	[self.navigationController 
		presentModalViewController:addNavController 
						  animated:YES];
	[addNavController release];
	[addController release];
}

- (void)contactAddViewController:
	(ContactsDetailViewController *)contactsDetailViewController
                   didAddContact:(BOOL)addedContact
{
	if (addedContact)
	{
		// Nothing to do, the contact is already added to the model
		// so save it and display it
		[model save];
		[model sort];
		[[self tableView] reloadData];
	}
	else
	{
		// Cancelled, so remove the last contact
		[model deleteRow:[model count]-1];
	}

	[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIViewController

//  Override inherited method to automatically refresh table view's data
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[model sort];
    [[self tableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Emergency List", @"Emergency List Header");

	// Acess the model
	EmergencyNumbersAppDelegate *appDelegate = 
		(EmergencyNumbersAppDelegate *)
			[[UIApplication sharedApplication] delegate];
	model = appDelegate.model;

    // Uncomment the following line to display an Edit button 
	// in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Setup the ADD button
	UIBarButtonItem *addButton = 
		[[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								 target:self 
								 action:@selector(addNew)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
}

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
    return model.count;
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
				 initWithStyle:UITableViewCellStyleSubtitle 
				 reuseIdentifier:CellIdentifier] 
					autorelease];
    }
    
    // Set up the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [model contactNameAtIndex:row];
	cell.detailTextLabel.text = [model contactNumberAtIndex:row];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[model setCurrentContactIndex:[indexPath row]];
	
	/* Old form
	ContactsDetailViewController *aContactsDetail = 
		[[ContactsDetailViewController alloc]
			initWithNibName:@"ContactsDetailView" bundle:nil];
	
	aContactsDetail.title = model.currentContactName;
	[aContactsDetail setModel:model];
	
	[self.navigationController
		pushViewController:aContactsDetail animated:YES];
	[aContactsDetail release];
	*/
	
	ItemTableViewController *aItemController =
		[[ItemTableViewController alloc] initWithNibName:@"ItemTableView" 
												  bundle:nil];
	
	aItemController.title = model.currentContactName;
	[aItemController setModel:model];
	
	[self.navigationController
		pushViewController:aItemController animated:YES];
	[aItemController release];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath
{  
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        // Delete the row from the data source
		NSUInteger row = [indexPath row];
		[model deleteRow:row];
		[model save];
		
		// And delete from the view
        [tableView deleteRowsAtIndexPaths:
			[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    //else if (editingStyle == UITableViewCellEditingStyleInsert)
	//{
        // Create a new instance of the appropriate class, insert it
		// into the array, and add a new row to the table view
    //}   
}


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

@end

