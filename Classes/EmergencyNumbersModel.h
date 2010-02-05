// ------------------------------------------------------------------------
//  EmergencyNumbersModel.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#define kFilename @"data.plist"

@interface EmergencyNumbersModel : NSObject
{
	NSMutableArray *contactsArray;
	
	NSUInteger currentContactIndex;
}

@property (nonatomic, assign) NSUInteger currentContactIndex;

//- (id)init;
- (NSUInteger)count;
- (BOOL)isButtonInUse:(NSString *)button;
- (NSString *)contactNameForButton:(NSString *)button;

// Virtual Accessors
- (NSString *)currentContactName;
- (void)setCurrentContactName:(NSString *)name;
- (NSString *)contactNameAtIndex:(NSUInteger)index;

- (NSString *)currentContactNumber;
- (void)setCurrentContactNumber:(NSString *)number;
- (NSString *)contactNumberAtIndex:(NSUInteger)index;

- (NSString *)currentContactButton;
- (void)setCurrentContactButton:(NSString *)button;
- (NSString *)contactButtonAtIndex:(NSUInteger)index;

- (NSString *)currentContactColor;
- (void)setCurrentContactColor:(NSString *)color;
- (NSString *)contactColorAtIndex:(NSUInteger)index;

//  Actions
- (void)save;
- (void)clearButton:(NSString *)button;
- (void)deleteRow:(NSUInteger)row;
- (void)addObject:(NSString *)name;

@end
