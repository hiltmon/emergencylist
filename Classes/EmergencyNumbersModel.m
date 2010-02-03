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

@end

@implementation EmergencyNumbersModel

@synthesize contactsArray;

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
		self.contactsArray = array;
		[array release];
	}
	else
	{
		// In DEBUG create a new file
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
		
		self.contactsArray = array;
		[array release];
	}
	
	return self;
}

- (void)dealloc
{
	[contactsArray dealloc];
	[super dealloc];
}

#pragma mark -

- (NSString *)dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
		NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

@end
