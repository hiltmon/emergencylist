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

#pragma mark -

- (void)dealloc
{
	[tempName dealloc];
	[tempNumber dealloc];
	
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

- (void)contactAddViewController:
	(ItemTableViewController *)ItemTableViewController
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
	cell.detailTextLabel.text = [model formattedContactNumberAtIndex:row];
	
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
		// Add from Address Book
		ABPeoplePickerNavigationController *picker =
			[[ABPeoplePickerNavigationController alloc] init];
		picker.peoplePickerDelegate = self;
		
		// Show only phone numbers in the details page
		NSArray *displayedItems = [NSArray arrayWithObjects:
			[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
		picker.displayedProperties = displayedItems;
		[self.navigationController presentModalViewController:picker 
													 animated:YES];
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

#pragma mark -
#pragma mark ABPeoplePickerNavigationController Delegate

// Cancel, hide it and do nothing
- (void)peoplePickerNavigationControllerDidCancel:
	(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
}

// Called when an attribute is picked.  Goodie.
- (BOOL)peoplePickerNavigationController:
	(ABPeoplePickerNavigationController *)peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property 
							  identifier:(ABMultiValueIdentifier)identifier
{
	// Get the data
	CFStringRef cfName = ABRecordCopyCompositeName(person);
	self.tempName = [NSString stringWithString:(NSString *)cfName];
	CFRelease(cfName);

	ABMultiValueRef container = ABRecordCopyValue(person, property);
	CFStringRef contactData = 
		ABMultiValueCopyValueAtIndex(container, identifier);
	CFRelease(container);
	
	// Strip () and -
	// TODO: Improve this mess
	NSMutableString *received = 
		[NSMutableString stringWithString:(NSString *)contactData];
	[received replaceOccurrencesOfString:@"(" 
							  withString:@"" 
								 options:NSCaseInsensitiveSearch 
								   range:NSMakeRange(0, [received length])];
	[received replaceOccurrencesOfString:@")" 
							  withString:@"" 
								options:NSCaseInsensitiveSearch 
								   range:NSMakeRange(0, [received length])];
	[received replaceOccurrencesOfString:@"-" 
							  withString:@"" 
								 options:NSCaseInsensitiveSearch 
								   range:NSMakeRange(0, [received length])];
	[received replaceOccurrencesOfString:@" " 
							  withString:@"" 
								 options:NSCaseInsensitiveSearch 
								   range:NSMakeRange(0, [received length])];
	self.tempNumber = received;
	CFRelease(contactData);
	
	// Hide it and close it
	[self dismissModalViewControllerAnimated:NO];
	
	// Trigger a create new after all this view has been cleared away
	// Calling the selector direcly seems to cause a crash
	// The zero in the delay means perform this seector next in the run loop
	// after all currently queued events
	[self performSelector:@selector(addNew) withObject:nil afterDelay:0];
	
	return NO;
}

// Called when a person is picked.  Since I want the user to
// pick a number, say NO.
- (BOOL)peoplePickerNavigationController:
	(ABPeoplePickerNavigationController *)peoplePicker
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
}

@end

