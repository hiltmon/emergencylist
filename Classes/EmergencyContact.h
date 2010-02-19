// ------------------------------------------------------------------------
//  EmergencyContact.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/19/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <Foundation/Foundation.h>


@interface EmergencyContact : NSObject
{
	NSDictionary *contact;
}

// ALERT: Assign, so it just wraps the dictionaries passed to it.
@property (nonatomic, assign) NSDictionary *contact;

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *number;
@property (nonatomic, assign) NSString *button;
@property (nonatomic, assign) NSString *color;
@property (nonatomic, assign) NSString *icon;

- (BOOL)isValid;	// Has a name and a number 

@end
