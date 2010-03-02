// ------------------------------------------------------------------------
//  PhoneNumberFormatter.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 3/2/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface PhoneNumberFormatter : NSObject
{
	NSDictionary *phoneNumberPatterns;
}

- (NSString *)stripToNumbers:(NSString *)number;

- (NSString *)format:(NSString *)inputNumber;
- (NSString *)format:(NSString *)inputNumber withLocale:(NSString *)locale;

@end
