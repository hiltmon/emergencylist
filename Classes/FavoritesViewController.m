// ------------------------------------------------------------------------
//  FavoritesViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "FavoritesViewController.h"
#import "EmergencyNumbersAppDelegate.h"	// Needed to get to the nav controller

@interface FavoritesViewController ()

- (void)setTitle:(NSString *)title forButton:(UIButton *)button;

@end

@implementation FavoritesViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;

/*
// The designated initializer.  Override if you create the controller 
// programmatically and want to perform customization that is not
// appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, 
// typically from a nib.
- (void)viewDidLoad
{
	// Get to the data by finding the application delegate
	EmergencyNumbersAppDelegate *appDelegate = 
		(EmergencyNumbersAppDelegate *)
			[[UIApplication sharedApplication] delegate];
	NSMutableArray *contactsArray = appDelegate.model.contactsArray;
	
	// Set the buttons...
	for (NSDictionary *item in contactsArray)
	{
		if ([item valueForKey:@"button"] == @"1")
		{
			[self setTitle:[item valueForKey:@"name"] forButton:button1];
		}
		
		if ([item valueForKey:@"button"] == @"2")
		{
			[self setTitle:[item valueForKey:@"name"] forButton:button2];
		}
	}
	
	[super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:
	(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

// Ugly in API, need to set the title of a button for all states
// TODO: Add comment, color and icon
- (void)setTitle:(NSString *)title forButton:(UIButton *)button
{
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateDisabled];
	[button setTitle:title forState:UIControlStateSelected];
}

@end
