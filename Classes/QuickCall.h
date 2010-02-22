// ------------------------------------------------------------------------
//  QuickCall.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/22/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#import "EmergencyContact.h"

@interface QuickCall : NSObject
{

}

+ (void)call:(EmergencyContact *)theContact;

@end
