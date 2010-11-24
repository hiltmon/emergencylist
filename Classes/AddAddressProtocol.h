// ------------------------------------------------------------------------
//  AddAddressProtocol.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 3/2/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

@protocol AddAddressProtocol

- (void)cancelAddressAdd;
- (void)addAddressName:(NSString *)name andNumber:(NSString *)number withImage:(UIImage *)image;

@end
