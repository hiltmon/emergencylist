// ------------------------------------------------------------------------
//  ContactsTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ContactsTableViewController.h"
#import "ItemTableViewController.h"
#import "EmergencyNumbersAppDelegate.h"	// Needed to get to model
#import "EmergencyNumbersModel.h"

@implementation ContactsTableViewController

@synthesize tempName;
@synthesize tempNumber;
@synthesize tempImage;

#pragma mark -

- (void)dealloc
{
	[tempName release];
	[tempNumber release];
    [tempImage release];
	
	[phoneNumberFormatter release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods

- (void)popupActionSheet
{
	UIActionSheet *popupQuery = 
		[[UIActionSheet alloc] initWithTitle:nil
									delegate:self
						   cancelButtonTitle:@"Cancel"
					  destructiveButtonTitle:nil
						   otherButtonTitles:@"Add from Address Book",
											 @"Add Manually",nil];
	
    [popupQuery showInView:self.tabBarController.view];
    [popupQuery release];
}

// Loser design - if the tempName is set, we've picked
// a contact, else do it manually.  Better way would be to plunk in
// a contact object as parameter ...  as soon as I redo the model
// to become a vector of contacts ...  maybe.
- (void)addNew
{
	[model addObject:@""];
	[model setCurrentContactIndex:[model count]-1];
	if (![tempName isEqualToString:@""])
	{
		[[model currentContact] setName:tempName];
		[[model currentContact] setNumber:tempNumber];
        [[model currentContact] setImage:tempImage];
        if (tempImage != nil)
        {
            [[model currentContact] setIcon:@"Photo"];   
        }
	}
	
	ItemTableViewController *addController = 
		[[ItemTableViewController alloc]
		 initWithNibName:@"ItemTableView" bundle:nil];
	addController.delegate = self;
	
	addController.title = kNewItem;
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

- (void)contactAddViewController:(id *)controller
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
		[model setCurrentContactIndex:0];	// Scroll to the top
	}

	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)cancelAddressAdd
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)addAddressName:(NSString *)name andNumber:(NSString *)number withImage:(UIImage *)image
{
	self.tempName = name;
	self.tempNumber = number;
    self.tempImage = image;
	[self.navigationController dismissModalViewControllerAnimated:NO];
	
	[self addNew];
}

#pragma mark -
#pragma mark UIViewController

//  Override inherited method to automatically refresh table view's data
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[model sort];
    [[self tableView] reloadData];

	// Scroll only if there are contacts
	if ([model count] > 0)
	{
		[[self tableView] 
			scrollToRowAtIndexPath:
				[NSIndexPath indexPathForRow:[model currentContactIndex] 
								   inSection:0]
					atScrollPosition:UITableViewScrollPositionMiddle 
						animated:YES];
	}
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
	
	// Setup the ADD button
	UIBarButtonItem *addButton = 
		[[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								 target:self 
								 action:@selector(popupActionSheet)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	// Setup the formatter
	phoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
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
	cell.detailTextLabel.text = 
		[phoneNumberFormatter format:[model contactNumberAtIndex:row]];
	
	// Set the text to gray if the name starts with a '<'
	NSString *prefix = 
		[cell.textLabel.text substringWithRange: NSMakeRange (0, 1)];
	if ([prefix isEqualToString:@"<"])
	{
		cell.textLabel.textColor = [UIColor grayColor];
	}
	else
	{
		cell.textLabel.textColor = [UIColor blackColor];
	}

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[model setCurrentContactIndex:[indexPath row]];
	
	ItemTableViewController *aItemController =
		[[ItemTableViewController alloc] initWithNibName:@"ItemTableView" 
												  bundle:nil];
	
	aItemController.title = @"Info";
	[aItemController setModel:model];
	
	[self.navigationController
		pushViewController:aItemController animated:YES];
	[aItemController release];
}

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

#pragma mark -
#pragma mark UIActionSheet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
	{
		AddressBookLookupTableViewController *picker = 
			[[AddressBookLookupTableViewController alloc]
				initWithNibName:@"AddressBookLookupView" bundle:nil];
		picker.delegate = self;
		[picker setTitle:@"Pick a Contact Number"];
		[picker setModel:model];
		
		UINavigationController *addNavController = 
			[[UINavigationController alloc]
			 initWithRootViewController:picker];
		
		[self.navigationController 
			presentModalViewController:addNavController 
				animated:YES];
		[addNavController release];
		[picker release];
    }
	else if (buttonIndex == 1)
	{
		// Add a blank contact
		self.tempName = @"";
		self.tempNumber = @"";
		
		[self addNew];
    }
}

@end

