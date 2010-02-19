// ------------------------------------------------------------------------
//  ItemTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/8/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ItemTableViewController.h"
#import "EmergencyNumbersModel.h"
#import "ButtonLookupTableViewController.h"
#import "ColorLookupTableViewController.h"
#import "IconLookupTableViewController.h"
#import "ContactsDetailViewController.h"

@implementation ItemTableViewController

@synthesize model;
@synthesize delegate;

#pragma mark -

- (void)dealloc
{
    [super dealloc];
}

- (void)callNumber
{
	NSString *callNumber = [[model currentContact] number];
	
	if (![callNumber isEqualToString:@""])
	{
		UIAlertView *callAlert = [[UIAlertView alloc]
							  initWithTitle:nil
							  message:
								  [NSString stringWithFormat:@"Calling %@", 
										callNumber]
							  delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil];
		[callAlert show];
		[callAlert release];
	}
	
}

- (void)cancelAdd
{
	[delegate contactAddViewController:self didAddContact:NO];
}

- (void)saveAdd
{
	[delegate contactAddViewController:self didAddContact:YES];
}

#pragma mark -
#pragma mark Action Methods


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// TODO: New plan, user could use this string!
	if ([[self title] isEqualToString:kNewItem])
	{
		// Add the save and cancel UI buttons
		// Setup the CANCEL button
		UIBarButtonItem *cancelButton = 
			[[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
				target:self 
				action:@selector(cancelAdd)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		// Setup the SAVE button
		UIBarButtonItem *saveButton = 
			[[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemSave
				target:self 
				action:@selector(saveAdd)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
	}
	else
	{
		// Setup the CALL button
		UIBarButtonItem *callButton = 
		[[UIBarButtonItem alloc] initWithTitle:@"Call" 
										 style:UIBarButtonItemStylePlain 
										target:self 
										action:@selector(callNumber)];
		self.navigationItem.rightBarButtonItem = callButton;
		[callButton release];
		
	}

}

//  Override inherited method to automatically refresh table view's data
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[self tableView] reloadData];
	
	if ([[self title] isEqualToString:kNewItem])
	{
		self.navigationItem.rightBarButtonItem.enabled = 
			[[model currentContact] isValid];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[model save];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    switch (section)
	{
		case NameSection:		return 2;
		case ButtonSection:		return 3;
	}
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case NameSection:  return @"Emergency Contact";
        case ButtonSection: return @"Quick Call Button";
    }
    
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

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
	EmergencyContact *theContact = [model currentContact];
	switch (section)
	{
		case NameSection:
			if (row == 0)
			{
				cell.textLabel.text = @"Name";
				cell.detailTextLabel.text = theContact.name;
			}
			else
			{
				cell.textLabel.text = @"Number";
				cell.detailTextLabel.text = model.formattedCurrentContactNumber;
			}

			break;
			
		case ButtonSection:
			if (row == 0)
			{
				cell.textLabel.text = @"Button";
				cell.detailTextLabel.text = 
					[model.buttonsArray objectAtIndex:
						[theContact.button intValue]];
			}
			else if (row == 1)
			{
				cell.textLabel.text = @"Color";
				cell.detailTextLabel.text = theContact.color;
			}
			else if (row == 2)
			{
				cell.textLabel.text = @"Icon";
				cell.detailTextLabel.text = theContact.icon;
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
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	switch (section)
	{
		case NameSection:
			;	// Violation in C99 BNF - cannot declare a variable at
				// the start of a case block
			ContactsDetailViewController *contactDetailController = 
				[[ContactsDetailViewController alloc]
					initWithNibName:@"ContactsDetailView" bundle:nil];
			
			[contactDetailController setTitle:@"Emergency Contact"];
			[contactDetailController setModel:model];
			[self.navigationController 
				pushViewController:contactDetailController animated:YES];
			[contactDetailController release];
			
			break;
			
		case ButtonSection:
			if (row == 0)
			{
				ButtonLookupTableViewController *buttonLookupController = 
					[[ButtonLookupTableViewController alloc]
						initWithNibName:@"ButtonLookupView" bundle:nil];
				[buttonLookupController setModel:model];
				[buttonLookupController setTitle:@"Which Quick Call Button?"];
				[self.navigationController 
					pushViewController:buttonLookupController animated:YES];
				[buttonLookupController release];
			}
			
			if (row == 1)
			{
				ColorLookupTableViewController *colorLookupController = 
					[[ColorLookupTableViewController alloc]
					 initWithNibName:@"ColorLookupView" bundle:nil];
				[colorLookupController setModel:model];
				[colorLookupController setTitle:@"Pick a Quick Call Color"];
				[self.navigationController 
					pushViewController:colorLookupController animated:YES];
				[colorLookupController release];
			}

			if (row == 2)
			{
				IconLookupTableViewController *iconLookupController = 
				[[IconLookupTableViewController alloc]
					initWithNibName:@"IconLookupView" bundle:nil];
				[iconLookupController setModel:model];
				[iconLookupController setTitle:@"Pick a Quick Call Icon"];
				[self.navigationController 
					pushViewController:iconLookupController animated:YES];
				[iconLookupController release];
			}
			
			break;
	}
}

@end

