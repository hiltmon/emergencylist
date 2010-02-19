// ------------------------------------------------------------------------
//  EmergencyNumbersAppDelegate.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#import "EmergencyNumbersModel.h"

@class ContactsNavController;

@interface EmergencyNumbersAppDelegate : NSObject 
	<UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *window;
	UITabBarController *tabBarController;
	ContactsNavController *contactsNavController;
	
	EmergencyNumbersModel *model;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet 
	UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet 
	ContactsNavController *contactsNavController;

@property (nonatomic, retain) EmergencyNumbersModel *model;

@end

