// ------------------------------------------------------------------------
//  AddItemProtocol.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 3/2/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

@protocol AddItemProtocol

- (void)contactAddViewController:(id *)controller
                   didAddContact:(BOOL)addedContact;

@end
