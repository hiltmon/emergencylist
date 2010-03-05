// ------------------------------------------------------------------------
//  AddressBookLookupTableViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 3/2/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "AddressBookLookupTableViewController.h"
#import "EmergencyNumbersModel.h"
#import "EmergencyContact.h";

@implementation AddressBookLookupTableViewController

@synthesize model;
@synthesize delegate;

#pragma mark -

- (void)dealloc
{
	[availableCallList release];
	
	[formatter release];
	
    [super dealloc];
}

- (void)cancelAdd
{
	[delegate cancelAddressAdd];
}

- (NSMutableArray *)loadAddressBook
{
	// Sets up 26 buckets
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < 26; i++)
	{
		NSMutableArray *letterArray = [[NSMutableArray alloc] init];
		[tempArray addObject:letterArray];
		[letterArray release];
	}
	
	// Build data source
	NSString *aName = @"";
	NSString *aLastName = @"";
	
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSArray *addresses = 
		(NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	for (int i = 0; i < [addresses count]; i++)
	{
		ABRecordRef person = [addresses objectAtIndex:i];
		
		// It is possible for address books to have no name entries
		CFStringRef cfName = ABRecordCopyCompositeName(person);
		if (cfName != nil)
		{
			aName = [NSString stringWithString:(NSString *)cfName];
			CFRelease(cfName);
		}
		else
		{
			aName = @"No Name";
		}

		
		CFStringRef cfSortName = ABRecordCopyValue(person, 
												   kABPersonLastNameProperty);
		if (cfSortName != nil)
		{
			aLastName = [NSString stringWithString:(NSString *)cfSortName];
			CFRelease(cfSortName);
		}
		else
		{
			aLastName = aName;
		}
		
		ABMultiValueRef container = ABRecordCopyValue(person, 
													  kABPersonPhoneProperty);
			
		for (CFIndex j = 0; j < ABMultiValueGetCount(container); j++)
		{
			CFStringRef phoneNumber = 
				ABMultiValueCopyValueAtIndex(container, j);
			NSString *aNumber = 
				[NSString stringWithString:(NSString *)phoneNumber];
			
			CFStringRef phoneType = ABMultiValueCopyLabelAtIndex(container, j);
			NSString *aType = [NSString stringWithString:(NSString *)phoneType];
			
			NSDictionary *callItem = 
				[[NSDictionary alloc] initWithObjectsAndKeys:
									  aName, @"name",
									  aNumber, @"number",
									  aType, @"type",
									  aLastName, @"sort", nil];
			int c = [[aLastName uppercaseString] characterAtIndex:0] - 65;
			// Set unicode - i.e. japanese to the end
			if ((c < 0) || (c > 25))
			{
				c = 25;
			}
			[[tempArray objectAtIndex:c] addObject:callItem];
			[callItem release];
			
			//CFRelease(phoneNumber);
		}

		CFRelease(container);
	}
	CFRelease(addressBook);
	[addresses release];
	
	return [tempArray autorelease];
}

#pragma mark -
#pragma mark Action Methods


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSMutableArray *tempArray = [self loadAddressBook]; 
	
	availableCallList = [[NSMutableArray alloc] init];
	availableCallIndex = [[NSMutableArray alloc] init];
		
	// Trim the sections
	int key = 0;
	for (int i = 0; i < [tempArray count]; i++)
	{
		NSArray *sectionArray = [tempArray objectAtIndex:i];
		if ([sectionArray count] != 0)
		{
			[availableCallList addObject:sectionArray];
			key++;
		}
		[availableCallIndex addObject:[NSNumber numberWithInt:key]];
	}
	
	// Sort each section
	NSSortDescriptor *descriptor1 = 
		[[[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES] 
			autorelease];
	NSSortDescriptor *descriptor2 = 
		[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] 
			autorelease];
	NSArray *descriptors = [NSArray arrayWithObjects:
							descriptor1, descriptor2, nil];
	for (int i = 0; i < [availableCallList count]; i++)
	{
		[[availableCallList objectAtIndex:i] sortUsingDescriptors:descriptors];
	}
	
	// Add the save and cancel UI buttons
	// Setup the CANCEL button
	UIBarButtonItem *cancelButton = 
	[[UIBarButtonItem alloc]
		initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
		target:self 
		action:@selector(cancelAdd)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	// Used to strip numbers
	formatter = [[PhoneNumberFormatter alloc] init];
}

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
    return [availableCallList count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [[availableCallList objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	// Get the first letter of the first object's sort
	NSArray *names = [availableCallList objectAtIndex:section];
	NSDictionary *name = [names objectAtIndex:0];
	NSString *keyString = [[name valueForKey:@"sort"] uppercaseString];
	return [NSString stringWithFormat:@"%c", [keyString characterAtIndex:0]];
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
				 initWithStyle:UITableViewCellStyleValue1 
				 reuseIdentifier:CellIdentifier] 
					autorelease];
    }
    
    // Set up the cell...
	NSUInteger section = [indexPath section];
	
	if ([[availableCallList objectAtIndex:section] count] == 0)
		return nil;
	
	NSUInteger row = [indexPath row];
	
	NSArray *sectionList = [availableCallList objectAtIndex:section];
	NSDictionary *callItem = [sectionList objectAtIndex:row];
	// Char 4 is the first letter in the label of the number that is unique
	cell.textLabel.text = [NSString stringWithFormat:@"%@ (%c)",
						   [callItem objectForKey:@"name"],
						   [[callItem objectForKey:@"type"] characterAtIndex:4]];
	cell.detailTextLabel.text = [callItem objectForKey:@"number"];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSArray *sectionList = [availableCallList objectAtIndex:section];
	NSDictionary *callItem = [sectionList objectAtIndex:row];
	[delegate addAddressName:[callItem objectForKey:@"name"] 
				   andNumber:[formatter stripToNumbers:
							  [callItem objectForKey:@"number"]]];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:
								 @"A", @"B", @"C", @"D", @"E",
								 @"F", @"G", @"H", @"I", @"J",
								 @"K", @"L", @"M", @"N", @"O",
								 @"P", @"Q", @"R", @"S", @"T",
								 @"U", @"V", @"W", @"X", @"Y",
								 @"Z", nil ];
	
	return tempArray;
}

- (NSInteger)tableView:(UITableView *)tableView 
sectionForSectionIndexTitle:(NSString *)title 
			   atIndex:(NSInteger)index
{
	NSInteger retValue = [[availableCallIndex objectAtIndex:index] intValue];
	return retValue - 1;	// Array is zero indexed
}

@end

