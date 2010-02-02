// ------------------------------------------------------------------------
//  EmergencyNumbersAppDelegate.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "EmergencyNumbersAppDelegate.h"
#import "ContactsNavController.h"

@implementation EmergencyNumbersAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize contactsNavController;
@synthesize model;

#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	EmergencyNumbersModel *aModel = [[EmergencyNumbersModel alloc] initialize];
	self.model = aModel;
	[aModel release];
	
	// Add the tab bar controller to the main window as a subview
	[window addSubview:tabBarController.view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)dealloc
{
	[model release];
	[contactsNavController release];
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end
