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

@synthesize contactsArray;

- (id)initialize
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
		
		NSMutableDictionary *element1 = [[NSMutableDictionary alloc] init];
		[element1 setObject:@"Contact 1" forKey:@"name"];
		[element1 setObject:@"1-555-0001" forKey:@"number"];
		[element1 setObject:@"1" forKey:@"button"];
		[array addObject:element1];
		[element1 release];
		
		NSMutableDictionary *element2 = [[NSMutableDictionary alloc] init];
		[element2 setObject:@"Contact 2" forKey:@"name"];
		[element2 setObject:@"1-555-0002" forKey:@"number"];
		[element2 setObject:@"2" forKey:@"button"];
		[array addObject:element2];
		[element2 release];
		
		NSMutableDictionary *element3 = [[NSMutableDictionary alloc] init];
		[element3 setObject:@"Contact 3" forKey:@"name"];
		[element3 setObject:@"1-555-0003" forKey:@"number"];
		[element3 setObject:@"0" forKey:@"button"];
		[array addObject:element3];
		[element3 release];
		
		self.contactsArray = array;
		[array release];
	}
	
	return self;
}

- (NSString *)dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
		NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

@end
