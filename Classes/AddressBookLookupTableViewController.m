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
	[availableCallIndex release];
	
	[formatter release];	
    [super dealloc];
}

- (void)cancelAdd
{
	[delegate cancelAddressAdd];
}

- (NSMutableArray *)createBaseArray
{
	// Sets up 26 buckets
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < 26; i++)
	{
		NSMutableArray *letterArray = [[NSMutableArray alloc] init];
		[tempArray addObject:letterArray];
		[letterArray release];
	}
	
	return [tempArray autorelease];
}

- (NSString *)extractDisplayName:(ABRecordRef)person
{
	NSString *aName = @"";
	
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
	
	return aName;
}

- (NSString *)extractSortName:(ABRecordRef)person
{
	NSString *aName = @"";
	
	CFStringRef cfSortName = ABRecordCopyValue(person, 
											   kABPersonLastNameProperty);

	if (cfSortName != nil)
	{
		aName = [NSString stringWithString:(NSString *)cfSortName];
		CFRelease(cfSortName);
	}
	
	return aName;
}

- (NSString *)determinePhoneType:(CFStringRef)phoneType
{
	// No category - no type
	if (phoneType == nil)
	{
		return @"";
	}
	
	NSString *aType = [NSString stringWithString:(NSString *)phoneType];
	
	// Using default Apple Addressbook category strings
	// Ignoring the rest
	if ([aType rangeOfString:@"FAX"].location != NSNotFound)
	{
		return @"F";
	}
	if ([aType rangeOfString:@"Mobile"].location != NSNotFound)
	{
		return @"M";
	}
	if ([aType rangeOfString:@"Home"].location != NSNotFound)
	{
		return @"H";
	}
	if ([aType rangeOfString:@"Work"].location != NSNotFound)
	{
		return @"W";
	}
	
	// Unknown category
	return @"";
}

- (void)processPerson:(ABRecordRef)person
			intoArray:(NSMutableArray *)array
{
	NSString *aName = [self extractDisplayName:person];
	NSString *aSortName = [self extractSortName:person];
	if ([aSortName isEqualToString:@""])
	{
		aSortName = aName;
	}
	
	ABMultiValueRef container = 
		ABRecordCopyValue(person, kABPersonPhoneProperty);
	
	for (CFIndex j = 0; j < ABMultiValueGetCount(container); j++)
	{	
		CFStringRef phoneNumber = 
			ABMultiValueCopyValueAtIndex(container, j);
		if (phoneNumber != nil)
		{
			NSString *aNumber = 
				[NSString stringWithString:(NSString *)phoneNumber];
			CFRelease(phoneNumber);
			
			// Skip blank phone numbers
			if ([aNumber isEqualToString:@""])
			{
				continue;
			}
			
			NSString *aType = [self determinePhoneType:
							   ABMultiValueCopyLabelAtIndex(container, j)];
			
			NSDictionary *callItem = 
				[[NSDictionary alloc] initWithObjectsAndKeys:
					aName, @"name",
					aNumber, @"number",
					aType, @"type",
					aSortName, @"sort", nil];
			
			// Add to letter index
			// Set unicode - i.e. japanese to the end
			int c = [[aSortName uppercaseString] characterAtIndex:0] - 65;
			if ((c < 0) || (c > 25))
			{
				c = 25;
			}
			[[array objectAtIndex:c] addObject:callItem];
			[callItem release];	
		}
	}
	
	CFRelease(container);
}

- (NSMutableArray *)loadAddressBook
{
	NSMutableArray *tempArray = [self createBaseArray];
	
	// Build data source
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSArray *addresses = 
		(NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	for (int i = 0; i < [addresses count]; i++)
	{
		ABRecordRef person = [addresses objectAtIndex:i];
		[self processPerson:person intoArray:tempArray];
	}
	CFRelease(addressBook);
	[addresses release];
	
	return tempArray;
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
	NSArray *sectionList = [availableCallList objectAtIndex:section];
	NSDictionary *callItem = [sectionList objectAtIndex:0];
	NSString *keyString = [[callItem valueForKey:@"sort"] uppercaseString];
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
	
	if ([[callItem objectForKey:@"type"] isEqualToString:@""])
	{
		cell.textLabel.text = [callItem objectForKey:@"name"];
	}
	else
	{
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",
							   [callItem objectForKey:@"name"],
							   [callItem objectForKey:@"type"]];
	}
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
	
	return [tempArray autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView 
sectionForSectionIndexTitle:(NSString *)title 
			   atIndex:(NSInteger)index
{
	NSInteger retValue = [[availableCallIndex objectAtIndex:index] intValue];
	return retValue - 1;	// Array is zero indexed
}

@end

