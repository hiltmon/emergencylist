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
}

@property (nonatomic, retain) NSMutableArray *contactsArray;

- (id)initialize;

@end
