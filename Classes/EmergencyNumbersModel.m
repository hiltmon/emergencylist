// ------------------------------------------------------------------------
//  EmergencyNumbersModel.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <stdlib.h>		// For random numbers
#import <time.h>

#import "EmergencyNumbersModel.h"

@interface EmergencyNumbersModel ()

- (NSString *)dataFilePath;
- (NSDictionary *)currentContactRecord;

@end

@implementation EmergencyNumbersModel

//@synthesize contactsArray;
@synthesize currentContactIndex;

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
		// TODO: Create a default file
		NSMutableArray *array = [[NSMutableArray alloc] init];
		srandom(time(NULL));
		
		for (int i = 1; i < 15; i++)
		{
			NSMutableDictionary *element1 = [[NSMutableDictionary alloc] init];
			[element1 setObject:[NSString stringWithFormat:@"Contact %d", i] 
						 forKey:@"name"];
			
			// Pick a random color
			int c = random() % 5;
			[element1 setObject:@"Default" forKey:@"color"];
			
			if (c == 1)
			{
				[element1 setObject:@"Red" forKey:@"color"];
			}
			
			if (c == 2)
			{
				[element1 setObject:@"Green" forKey:@"color"];
			}
			
			if (c == 3)
			{
				[element1 setObject:@"Blue" forKey:@"color"];
			}
			
			if (c == 4)
			{
				[element1 setObject:@"Yellow" forKey:@"color"];
			}
			
			if (i < 10)
			{
				[element1 
					setObject:[NSString stringWithFormat:@"1-917-555-000%d", i]  
					   forKey:@"number"];
			}
			else 
			{
				[element1
					setObject:[NSString stringWithFormat:@"1-917-555-00%d", i]  
						forKey:@"number"];
			}
			
			if ((i % 3 == 0) && (i < 16))
			{
				[element1 setObject:[NSString stringWithFormat:@"%d", i/3] 
							 forKey:@"button"];
			}
			else
			{
				[element1 setObject:@"0" forKey:@"button"];
			}
			
			[array addObject:element1];
			[element1 release];
		}
		
		contactsArray = [array retain];
		[array release];
	}
	
	return self;
}

- (void)dealloc
{
	[contactsArray dealloc];
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

- (NSString *)contactNameForButton:(NSString *)button
{
	for (NSDictionary *item in contactsArray)
	{
		if ([[item valueForKey:@"button"] isEqualToString:button])
		{
			return [item valueForKey:@"name"];
		}
	}
	
	return @"";
}

- (NSDictionary *)currentContactRecord
{
	return [contactsArray objectAtIndex:self.currentContactIndex];
}

#pragma mark -
#pragma mark Virtual Accessors

- (NSString *)currentContactName
{
	return [self contactNameAtIndex:self.currentContactIndex];
}

- (void)setCurrentContactName:(NSString *)name
{
	[[self currentContactRecord] setValue:name forKey:@"name"];
}

- (NSString *)contactNameAtIndex:(NSUInteger)index
{
	return [[contactsArray objectAtIndex:index] valueForKey:@"name"];
}

- (NSString *)currentContactNumber
{
	return [self contactNumberAtIndex:self.currentContactIndex];
}

- (void)setCurrentContactNumber:(NSString *)number
{
	[[self currentContactRecord] setValue:number forKey:@"number"];
}

- (NSString *)contactNumberAtIndex:(NSUInteger)index
{
	return [[contactsArray objectAtIndex:index] valueForKey:@"number"];
}

- (NSString *)currentContactButton
{
	return [self contactButtonAtIndex:self.currentContactIndex];
}

- (void)setCurrentContactButton:(NSString *)button
{
	[[self currentContactRecord] setValue:button forKey:@"button"];
}

- (NSString *)contactButtonAtIndex:(NSUInteger)index
{
	return [[contactsArray objectAtIndex:index] valueForKey:@"button"];
}

- (NSString *)currentContactColor
{
	return [self contactColorAtIndex:self.currentContactIndex];
}

- (void)setCurrentContactColor:(NSString *)color
{
	[[self currentContactRecord] setValue:color forKey:@"color"];
}

- (NSString *)contactColorAtIndex:(NSUInteger)index
{
	return [[contactsArray objectAtIndex:index] valueForKey:@"color"];
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

@end
