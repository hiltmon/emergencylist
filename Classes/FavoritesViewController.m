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

#pragma mark -

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

#pragma mark -
#pragma mark UIViewController

// Implement viewDidLoad to do additional setup after loading the view, 
// typically from a nib.
- (void)viewDidLoad
{
	button1.hidden = YES;
	button2.hidden = YES;
	button3.hidden = YES;
	button4.hidden = YES;
	button5.hidden = YES;
	
	// Testing button colors
	[button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	UIImage *buttonBackground = [UIImage imageNamed:@"RedButton.png"];
	UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button1 setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *buttonPressedBackground = [UIImage imageNamed:@"GrayButton.png"];
	UIImage *newPressedImage = [buttonPressedBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button1 setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	// In case the parent draws a back image
	button1.backgroundColor = [UIColor clearColor];
	
	// Get to the data by finding the application delegate
	EmergencyNumbersAppDelegate *appDelegate = 
		(EmergencyNumbersAppDelegate *)
			[[UIApplication sharedApplication] delegate];
	NSMutableArray *contactsArray = appDelegate.model.contactsArray;
	
	// Set the buttons...
	for (NSDictionary *item in contactsArray)
	{
		if ([[item valueForKey:@"button"] isEqualToString:@"1"])
		{
			[self setTitle:[item valueForKey:@"name"] forButton:button1];
			button1.hidden = NO;
		}
		
		if ([[item valueForKey:@"button"] isEqualToString:@"2"])
		{
			[self setTitle:[item valueForKey:@"name"] forButton:button2];
			button2.hidden = NO;
		}
			 
		if ([[item valueForKey:@"button"] isEqualToString:@"3"])
		{
			[self setTitle:[item valueForKey:@"name"] forButton:button3];
			button3.hidden = NO;
		}
		
		if ([[item valueForKey:@"button"] isEqualToString:@"4"])
		{
			[self setTitle:[item valueForKey:@"name"] forButton:button4];
			button4.hidden = NO;
		}
		
		if ([[item valueForKey:@"button"] isEqualToString:@"5"])
		{
			[self setTitle:[item valueForKey:@"name"] forButton:button5];
			button5.hidden = NO;
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

@end
