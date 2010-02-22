// ------------------------------------------------------------------------
//  FavoritesViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "FavoritesViewController.h"
#import "EmergencyNumbersAppDelegate.h"	// Needed to get to model
#import "EmergencyNumbersModel.h"

#import "QuickCall.h"

// Private methods
@interface FavoritesViewController ()

- (void)reloadData;

@end

@implementation FavoritesViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize button6;
@synthesize startImage;

#pragma mark -

- (void)dealloc
{
	[buttonArray dealloc];
	
    [super dealloc];
}

- (void)reloadData
{
	// Set the buttons
	BOOL areButtonsVisible = NO;
	for (int i = 1; i <= 6; i++)
	{
		EmergencyContact *theContact = [model contactForButton:i];
		if (theContact == nil) 
		{
			// Create a Gray button
			[[buttonArray objectAtIndex:i-1] setTitle:@""
												color:@"Gray"
												 icon:@"None"];
		}
		else
		{
			[[buttonArray objectAtIndex:i-1] setTitle:theContact.name 
												color:theContact.color
												 icon:theContact.icon];
			areButtonsVisible = YES;
		}
	}
	
	// Show start image if no buttons visible
	startImage.hidden = areButtonsVisible;
	for (UIButton *button in buttonArray)
	{
		button.hidden = !areButtonsVisible;
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction) buttonPressed:(id)sender
{
	// Get the index
	NSUInteger whichButton = [buttonArray indexOfObject:sender]+1;
	EmergencyContact *theContact = [model contactForButton:whichButton];
	
	[QuickCall call:theContact];
}

#pragma mark -
#pragma mark UIViewController

//  Override inherited method to automatically refresh table view's data
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, 
// typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Access the model
	EmergencyNumbersAppDelegate *appDelegate = 
		(EmergencyNumbersAppDelegate *)
			[[UIApplication sharedApplication] delegate];
	model = appDelegate.model;
	
	buttonArray = [[NSArray alloc] initWithObjects:button1, button2,
				   button3, button4, button5, button6, nil];
	
	[self reloadData];
}

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

@end
