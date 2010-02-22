// ------------------------------------------------------------------------
//  EmergencyNumbersModel.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "EmergencyNumbersModel.h"

@interface EmergencyNumbersModel ()

- (NSString *)dataFilePath;

@end

@implementation EmergencyNumbersModel

@synthesize currentContactIndex;
@synthesize buttonsArray;
@synthesize colorsArray;
@synthesize iconsArray;

#pragma mark -
#pragma mark init and dealloc

- (id)init
{
	// Load the data file if one exists
	NSString *filePath = [self dataFilePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		// Load the file
		NSMutableArray *array = [[NSMutableArray alloc] 
								 initWithContentsOfFile:filePath];
		contactsArray = [array retain];
		[array release];
	}
	else
	{
		// Creating a Defult File - Its Blank
		// TODO: Use address book???
		NSMutableArray *array = [[NSMutableArray alloc] init];
		contactsArray = [array retain];
		[array release];
	}
	
	// Setup the master arrays
	buttonsArray = [[NSArray alloc] initWithObjects:@"No Button",
					@"Top Left", @"Top Right",
					@"Middle Left", @"Middle Right", 
					@"Bottom Left", @"Bottom Right", nil];
	
	colorsArray = [[NSArray alloc] initWithObjects:@"Default",
					@"Red", @"Green",
					@"Blue", @"Yellow",
				    @"Cyan", @"Pink", @"Purple", nil];
	
	iconsArray = [[NSArray alloc] initWithObjects:@"Default",
				   @"Fire", @"Government", @"Home",
				   @"Insurance", @"Medical", @"Money", 
				   @"Office", @"Person", @"Police",
				   @"Power", @"Religion", @"School", 
				   @"Work", nil];
	
	return self;
}

- (void)dealloc
{
	[contactsArray dealloc];
	[buttonsArray dealloc];
	[colorsArray dealloc];
	[iconsArray dealloc];
	
	[super dealloc];
}

- (NSString *)dataFilePath
{
	NSArray *paths = 
		NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
											NSUserDomainMask, 
											YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (NSUInteger)count
{
	return [contactsArray count];
}

- (BOOL)isButtonInUse:(NSString *)button
{
	if ([button isEqualToString:@"0"])
	{
		return NO;
	}
	
	for (NSDictionary *item in contactsArray)
	{
		if ([[item valueForKey:@"button"] isEqualToString:button])
		{
			return YES;
		}
	}
	
	return NO;
}

- (EmergencyContact *)contactForButton:(NSUInteger)button
{
	if ((button == 0) || (button > 6))
	{
		return nil;
	}
	
	NSString *buttonKey = [NSString stringWithFormat:@"%d", button];
	
	for (NSDictionary *item in contactsArray)
	{
		if ([[item valueForKey:@"button"] isEqualToString:buttonKey])
		{
			EmergencyContact *theContact =
				[[[EmergencyContact alloc] init] autorelease];
			theContact.contact = item;
			return theContact;
		}
	}
	
	return nil;
}

- (NSString *)formatPhoneNumber:(NSString *)phoneNumber
{
	if ([phoneNumber isEqualToString:@""])
	{
		return phoneNumber;
	}
	
	// ALERT: USA Only, need to implement locales...
	NSMutableString *formatted = 
		[[NSMutableString alloc] initWithString:phoneNumber];
	
	// Has 1 prefix?
	NSString *prefix = [phoneNumber substringWithRange: NSMakeRange (0, 1)];
	if (!([prefix isEqualToString:@"1"]) && ([phoneNumber length] > 7))
	{
		// insert the 1
		[formatted insertString:@"1" atIndex:0];
	}
	
	// Here either 1xxxxxxxxxx or xxxxxxx
	if ([formatted length] == 7)
	{
		[formatted insertString:@"-" atIndex:3];
	}
	
	if ([formatted length] == 11)
	{
		[formatted insertString:@"-" atIndex:7];
		[formatted insertString:@") " atIndex:4];
		[formatted insertString:@" (" atIndex:1];
	}

	return [formatted autorelease];
}

#pragma mark -
#pragma mark Virtual Accessors


- (EmergencyContact *)currentContact
{
	EmergencyContact *theContact =
	[[[EmergencyContact alloc] init] autorelease];
	theContact.contact = [contactsArray objectAtIndex:self.currentContactIndex];
	return theContact;
}

- (NSString *)contactNameAtIndex:(NSUInteger)index
{
	// If blank, reply with a nice blank name.
	NSString *contactName = 
		[[contactsArray objectAtIndex:index] valueForKey:@"name"];
	if ((contactName == nil) || ([contactName isEqualToString:@""]))
	{
		contactName = 
			[NSString stringWithFormat:@"<Blank Contact %d>", index];
	}
	return contactName;
}

- (NSString *)formattedCurrentContactNumber
{
	return [self formattedContactNumberAtIndex:self.currentContactIndex];
}

- (NSString *)formattedContactNumberAtIndex:(NSUInteger)index
{
	return [self formatPhoneNumber:
			[[contactsArray objectAtIndex:index] valueForKey:@"number"]];
}

#pragma mark -
#pragma mark Actions

- (void)clearButton:(NSString *)button
{
	for (NSDictionary *item in contactsArray)
	{
		if ([[item valueForKey:@"button"] isEqualToString:button])
		{
			[item setValue:@"0" forKey:@"button"];
		}
	}
}

- (void)save
{
	NSString *filePath = [self dataFilePath];
	[contactsArray writeToFile:filePath atomically:YES];
}

- (void)sort
{
	// Cannot sort an empty array
	if ([contactsArray count] == 0)
	{
		return;
	}
	
	NSString *oldContactName = [[[self currentContact] name] copy];
	
	NSSortDescriptor *descriptor = 
		[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] 
			autorelease];
	NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
	[contactsArray sortUsingDescriptors:descriptors];
	
	[self setCurrentContactIndex:0];
	// Find the contact index where this is the name
	for (int i = 0; i < [contactsArray count]; i++)
	{
		if ([[[contactsArray objectAtIndex:i] valueForKey:@"name"] 
			 isEqualToString:oldContactName])
		{
			[self setCurrentContactIndex:i];
		}
	}
	
	[oldContactName release];
}

- (void)deleteRow:(NSUInteger)row
{
	[contactsArray removeObjectAtIndex:row];
}

- (void)addObject:(NSString *)name
{
	NSMutableDictionary *newItem = [[NSMutableDictionary alloc] init];
	[newItem setObject:name forKey:@"name"];
	[newItem setObject:@"Default" forKey:@"color"];
	[newItem setObject:@"" forKey:@"number"];
	[newItem setObject:@"0" forKey:@"button"];
	[newItem setObject:@"Default" forKey:@"icon"];
	
	[contactsArray addObject:newItem];
	[newItem release];
}

@end
