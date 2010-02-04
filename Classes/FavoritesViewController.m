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

// Private methods
@interface FavoritesViewController ()

- (void)setTitle:(NSString *)title 
		andColor:(NSString *)myColor 
	   forButton:(UIButton *)button;
- (void)reloadData;

@end

@implementation FavoritesViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;

#pragma mark -

- (void)dealloc
{
    [super dealloc];
}

// Ugly in API, need to set the title of a button for all states
// TODO: Add comment and icon
- (void)setTitle:(NSString *)title 
		andColor:(NSString *)myColor 
	   forButton:(UIButton *)button
{
	// Set the title to be the same for ALL states
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateDisabled];
	[button setTitle:title forState:UIControlStateSelected];
	
	// TODO: Optimize by cacheing images
	// Create the button backgrounds
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	NSString *backgroundImageName = 
		[NSString stringWithFormat:@"%@Button.png", myColor];
	UIImage *buttonBackground = [UIImage imageNamed:backgroundImageName];
	UIImage *newImage = [buttonBackground 
						 stretchableImageWithLeftCapWidth:12.0 
						 topCapHeight:0.0];
	[button setBackgroundImage:newImage 
					   forState:UIControlStateNormal];
	
	// Pressed is always Gray
	UIImage *buttonPressedBackground = [UIImage imageNamed:@"GrayButton.png"];
	UIImage *newPressedImage = [buttonPressedBackground 
								stretchableImageWithLeftCapWidth:12.0 
								topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage 
					   forState:UIControlStateHighlighted];
	
	// In case the parent draws a back image
	button.backgroundColor = [UIColor clearColor];
}

- (void)reloadData
{
	button1.hidden = YES;
	button2.hidden = YES;
	button3.hidden = YES;
	button4.hidden = YES;
	button5.hidden = YES;
	
	// Set the buttons...
	for (int i = 0; i < [model count]; i++)
	{
		if ([[model contactButtonAtIndex:i] isEqualToString:@"1"])
		{
			[self setTitle:[model contactNameAtIndex:i] 
				  andColor:[model contactColorAtIndex:i]
				 forButton:button1];
			button1.hidden = NO;
		}
		
		if ([[model contactButtonAtIndex:i] isEqualToString:@"2"])
		{
			[self setTitle:[model contactNameAtIndex:i]
				  andColor:[model contactColorAtIndex:i]
				 forButton:button2];
			button2.hidden = NO;
		}
		
		if ([[model contactButtonAtIndex:i] isEqualToString:@"3"])
		{
			[self setTitle:[model contactNameAtIndex:i]
				  andColor:[model contactColorAtIndex:i]
				 forButton:button3];
			button3.hidden = NO;
		}
		
		if ([[model contactButtonAtIndex:i] isEqualToString:@"4"])
		{
			[self setTitle:[model contactNameAtIndex:i] 
				  andColor:[model contactColorAtIndex:i]
				 forButton:button4];
			button4.hidden = NO;
		}
		
		if ([[model contactButtonAtIndex:i] isEqualToString:@"5"])
		{
			[self setTitle:[model contactNameAtIndex:i] 
				  andColor:[model contactColorAtIndex:i]
				 forButton:button5];
			button5.hidden = NO;
		}
	}
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
