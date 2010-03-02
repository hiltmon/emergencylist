// ------------------------------------------------------------------------
//  PhoneNumberFormatter.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 3/2/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "PhoneNumberFormatter.h"

@interface PhoneNumberFormatter ()

- (NSString *)selectPattern:(NSArray *)patterns 
				  forNumber:(NSString *)number;
- (BOOL)matchLength:(NSString *)pattern 
		 withNumber:(NSString *)number;
- (BOOL)matchStart:(NSString *)pattern 
		withNumber:(NSString *)number;
- (BOOL)isValidInPhoneNumber:(char)c;

@end

@implementation PhoneNumberFormatter

#pragma mark -

- (id)init
{
	NSArray *usPatterns = [[NSArray alloc] initWithObjects:
						  @"+1 (###) ###-####",
						  @"1 (###) ###-####",
						  @"011 (###) ###-####",
						  @"(###) ###-####",
						  @"###-####",
						  nil];
	
	NSArray *gbPatterns = [[NSArray alloc] initWithObjects:
						   @"01### ######",
						   @"02# ### ####",
						   @"07### ######",
						   @"#### ###-####",
						   @"###-####",
						   nil];
	
	NSArray *auPatterns = [[NSArray alloc] initWithObjects:
						   @"+61 4## ### ###",
						   @"+61 # #### ####",
						   @"02 #### ####",
						   @"2 #### ####",
						   @"04## ### ###",		// Mobiles
						   @"####-####",
						   nil];
	
	NSArray *frPatterns = [[NSArray alloc] initWithObjects:
						   @"## ## ## ## ##",
						   nil];
	
	NSArray *dePatterns = [[NSArray alloc] initWithObjects:
						   @"### #######",
						   nil];
	
	NSArray *arPatterns = [[NSArray alloc] initWithObjects:
						   @"9 ### #### ####",
						   @"9 #### ## ####",
						   @"#### ## ####",
						   @"#### ####",
						   @"### ####",
						   @"### ###",
						   nil];
	
	NSArray *brPatterns = [[NSArray alloc] initWithObjects:
						   @"## #### ####",
						   nil];
	
	NSArray *jpPatterns = [[NSArray alloc] initWithObjects:
						   @"## #### ####",
						   nil];
	
	phoneNumberPatterns = [[NSDictionary alloc] initWithObjectsAndKeys:
			usPatterns, @"en_US",
			usPatterns, @"en_CA",
 		    gbPatterns, @"en_GB",
			auPatterns, @"en_AU",
		    frPatterns, @"fr_FR",
			dePatterns, @"de_DE",
			arPatterns, @"es_AR",
			brPatterns, @"pt_BR",
		    jpPatterns, @"ja_JP",
			nil];
	
	[usPatterns release];
	[gbPatterns release];
	[auPatterns release];
	[frPatterns release];
	[dePatterns release];
	[arPatterns release];
	[brPatterns release];
	[jpPatterns release];
	
	return self;
}

- (void)dealloc
{
	[phoneNumberPatterns release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Actions

- (NSString *)format:(NSString *)inputNumber
{
	NSLocale *currentUsersLocale = [NSLocale currentLocale];
	//NSLog(@"Current Locale: %@", [currentUsersLocale localeIdentifier]);
	return [self format:inputNumber 
			 withLocale:[currentUsersLocale localeIdentifier]];
}

- (NSString *)format:(NSString *)inputNumber withLocale:(NSString *)locale
{
	//NSLog(@"Formatting [%@] using locale [%@]", inputNumber, locale);
	NSArray *patterns = [phoneNumberPatterns objectForKey:locale];
	if (patterns == nil)
	{
		//NSLog(@"No patterns found for locale...");
		return inputNumber;
	}
	
	NSString *input = [self stripToNumbers:inputNumber];	
	NSString *pattern = [self selectPattern:patterns forNumber:input];
	if (pattern == nil)
	{
		//NSLog(@"No matching pattern found...");
		return inputNumber;	// Return stripped number??
	}
	
	// Format to  pattern
	//NSLog(@"Using Pattern: %@", pattern);
	
	NSMutableString *result = [[NSMutableString alloc] init];
	int patternIndex = 0;
	int numberIndex = 0;
	while (patternIndex < [pattern length])
	{
		char patternChar = [pattern characterAtIndex:patternIndex];
		
		switch (patternChar)
		{
			case '#':
				[result appendFormat:@"%c", [input characterAtIndex:numberIndex]];
				numberIndex++; 
				break;
				
			default:
				[result appendFormat:@"%c", patternChar];
				// Strip matching characters
				if (patternChar == [input characterAtIndex:numberIndex])
				{
					numberIndex++;
				}
				break;
		}
		patternIndex++;
	}
	
	return [result autorelease];
}

#pragma mark -
#pragma mark Utilities

- (NSString *)selectPattern:(NSArray *)patterns 
				  forNumber:(NSString *)number
{
	// No patterns in array
	if ([patterns count] < 1)
	{
		//NSLog (@"ALERT: No patterns in array!!");
		return nil;
	}
	
	// Try to match the first character in the pattern
	// then the length
	for (NSString *pattern in patterns)
	{
		if ([self matchStart:pattern withNumber:number])
		{
			if ([self matchLength:pattern withNumber:number])
			{
				return pattern;
			}
		}
	}
	
	// No match, no pattern
	return nil;
}

- (BOOL)matchLength:(NSString *)pattern 
		 withNumber:(NSString *)number
{
	int count = 0;
	// Count the # in pattern
	for (int i = 0; i < [pattern length]; i++)
	{
		char c = [pattern characterAtIndex:i];
		if ((c == '#') || ([self isValidInPhoneNumber:c]))
		{
			count++;
		}
	}
	
	//NSLog(@"matchLength pattern %@ with number %@ is %d", pattern, number, count);
	return ([number length] == count);
}

// Match the first characters until we hit a (- or #
- (BOOL)matchStart:(NSString *)pattern 
		withNumber:(NSString *)number
{
	if ((number == nil) || ([number length] == 0))
	{
		return NO;
	}
	
	int i = 0;
	while ([self isValidInPhoneNumber:[pattern characterAtIndex:i]])
	{
		if ([pattern characterAtIndex:i] != [number characterAtIndex:i])
		{
			//NSLog(@"matchStart NO pattern %@ with number %@", pattern, number);
			return NO;
		}
		i++;
	}
	
	//NSLog(@"matchStart YES pattern %@ with number %@", pattern, number);
	return YES;
}

- (NSString *)stripToNumbers:(NSString *)number
{
	NSMutableString *result = [[NSMutableString alloc] init];
	for (int i = 0; i < [number length]; i++)
	{
		char c = [number characterAtIndex:i];
		if ([self isValidInPhoneNumber:c])
		{
			[result appendFormat:@"%c", c];
		}
	}
	return [result autorelease];
}

// Only digits and the international prefix of + are valid
- (BOOL)isValidInPhoneNumber:(char)c
{
	if (c == '+')
	{
		return YES;
	}
	
	if (c >= '0' && c <= '9')
	{
		return YES;
	}
	
	return NO;
}

@end
