// ------------------------------------------------------------------------
//  QuickCall.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/22/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "QuickCall.h"

@interface QuickCall ()

+ (void)alertWithTitle:(NSString *)theTitle 
			   message:(NSString *)theMessage;

@end


@implementation QuickCall

+ (void)alertWithTitle:(NSString *)theTitle 
			   message:(NSString *)theMessage
{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:theTitle
								message:theMessage
								delegate:self 
								cancelButtonTitle:@"OK" 
								otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)call:(EmergencyContact *)theContact
{
	if (theContact == nil)
	{
		return;
	}
	
	if ([theContact.number isEqualToString:@""])
	{
		[self alertWithTitle:@"Unable to Call" 
					 message:@"No number set to call"];
	}
	else
	{
		NSUInteger numberLength = [theContact.number length];
        if (numberLength >= 7)
        {
            NSString *areaCode = [theContact.number substringWithRange: 
							  NSMakeRange (numberLength-7, 3)];
		
            //NSLog(@"Area Code: %@", areaCode);
            if ([areaCode isEqualToString:@"555"])
            {
                [self alertWithTitle:@"Movie Number"
                             message:[NSString stringWithFormat:@"Calling %@", 
                                      theContact.number]];
                return;
            }
        }
        
        // If its an iPhone, make the call
        NSString *deviceType = [UIDevice currentDevice].model;
        if ([deviceType isEqualToString:@"iPhone"])
        {
            // Call it
            NSString *phoneString = [NSString stringWithFormat:@"tel:%@", 
                                     theContact.number];
            NSURL *phoneNumberURL = [NSURL URLWithString:phoneString];
            [[UIApplication sharedApplication] openURL:phoneNumberURL];
        }
        else
        {
            [self alertWithTitle:@"No Phone on Device"
                         message:[NSString stringWithFormat:@"Please Call %@", 
                                  theContact.number]];
        }
	}
	
}

@end
