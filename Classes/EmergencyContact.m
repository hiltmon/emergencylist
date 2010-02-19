// ------------------------------------------------------------------------
//  EmergencyContact.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/19/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "EmergencyContact.h"

@implementation EmergencyContact

@synthesize contact;

- (NSString *)name
{
	return [contact valueForKey:@"name"];
}

- (void)setName:(NSString *)newName
{
	[contact setValue:newName forKey:@"name"];
}

- (NSString *)number
{
	return [contact valueForKey:@"number"];
}

- (void)setNumber:(NSString *)newNumber
{
	[contact setValue:newNumber forKey:@"number"];
}

- (NSString *)button
{
	return [contact valueForKey:@"button"];
}

- (void)setButton:(NSString *)newButton
{
	[contact setValue:newButton forKey:@"button"];
}

- (NSString *)color
{
	return [contact valueForKey:@"color"];
}

- (void)setColor:(NSString *)newColor
{
	[contact setValue:newColor forKey:@"color"];
}

- (NSString *)icon
{
	return [contact valueForKey:@"icon"];
}

- (void)setIcon:(NSString *)newIcon
{
	[contact setValue:newIcon forKey:@"icon"];
}

- (BOOL)isValid
{
	return !([[contact valueForKey:@"name"] isEqualToString:@""]
			|| [[contact valueForKey:@"number"] isEqualToString:@""]);
}

@end
