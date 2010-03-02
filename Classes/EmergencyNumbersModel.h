// ------------------------------------------------------------------------
//  EmergencyNumbersModel.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import "EmergencyContact.h"

#define kFilename @"data.plist"

@interface EmergencyNumbersModel : NSObject
{
	NSMutableArray *contactsArray;
	NSArray *buttonsArray;
	NSArray *colorsArray;
	NSArray *iconsArray;
	
	NSUInteger currentContactIndex;
}

@property (nonatomic, assign) NSUInteger currentContactIndex;
@property (nonatomic, readonly) NSArray *buttonsArray;
@property (nonatomic, readonly) NSArray *colorsArray;
@property (nonatomic, readonly) NSArray *iconsArray;

//- (id)init;
- (NSUInteger)count;
- (BOOL)isButtonInUse:(NSString *)button;
- (EmergencyContact *)contactForButton:(NSUInteger)button;

// Virtual Accessors
- (EmergencyContact *)currentContact;
- (NSString *)contactNameAtIndex:(NSUInteger)index;
- (NSString *)contactNumberAtIndex:(NSUInteger)index;

//  Actions
- (void)save;
- (void)sort;
- (void)clearButton:(NSString *)button; // All instances of button are cleared
- (void)deleteRow:(NSUInteger)row;
- (void)addObject:(NSString *)name;

@end
