// ------------------------------------------------------------------------
//  ContactsDetailViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ContactsDetailViewController.h"
#import "EmergencyNumbersModel.h"

@interface ContactsDetailViewController ()

- (void)setButton:(NSString *)button;

@end

@implementation ContactsDetailViewController

@synthesize nameField;
@synthesize numberField;
@synthesize favoriteSegmentedControl;
@synthesize colorSegmentedControl;

@synthesize model;

#pragma mark -

- (void)dealloc
{
	// Clear outlets or [CALayer release] tries to release these again
	nameField = nil;
	numberField = nil;
	favoriteSegmentedControl = nil;
	colorSegmentedControl = nil;
	
	[nameField dealloc];
	[numberField dealloc];
	[favoriteSegmentedControl dealloc];
	[colorSegmentedControl dealloc];
	
	oldButton = nil;
	[oldButton dealloc];

    [super dealloc];
}

- (void)setButton:(NSString *)button
{
	[model clearButton:button];
	[model setCurrentContactButton:button];
	[oldButton release];
	oldButton = [button copy];
	
	[model save];
}

- (void)favoritesSegmentAction:(id)sender
{
	NSString *whichButton = [NSString stringWithFormat:@"%d", 
							 [favoriteSegmentedControl selectedSegmentIndex]];
	
	if ([whichButton isEqualToString:oldButton])
	{
		return;
	}
	
	if ([model isButtonInUse:whichButton])
	{
		// Open a alert
		// TODO: Fixup strings
		NSString *message = 
			[NSString stringWithFormat:
				@"Used by %@, do you still want to change it?",
					[model contactNameForButton:whichButton]];
		UIAlertView *alert = 
			[[UIAlertView alloc] initWithTitle:@"Button In Use" 
									   message:message
									  delegate:self 
							 cancelButtonTitle:@"No" 
							 otherButtonTitles:@"Yes", nil];
		[alert show];
		[alert release];
	}
	else
	{
		[self setButton:whichButton];
	}
}

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		// YES
		NSString *whichButton = [NSString stringWithFormat:@"%d", 
								 [favoriteSegmentedControl selectedSegmentIndex]];
		[self setButton:whichButton];
	}
	else
	{
		// NO
		[favoriteSegmentedControl setSelectedSegmentIndex:
			[oldButton intValue]];
	}
}

- (void)colorSegmentAction:(id)sender
{
	NSString *whichColor = [NSString stringWithFormat:@"%@", 
		 [colorSegmentedControl titleForSegmentAtIndex:[
				colorSegmentedControl selectedSegmentIndex]]];
	[model setCurrentContactColor:whichColor];
	
	[model save];
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)textFieldDoneEditing:(id)sender
{
	// Hide the keyboard
	[sender resignFirstResponder];
	
	[model save];
}

- (IBAction)textFieldValueChanged:(id)sender
{
	if (sender == nameField)
	{
		[model setCurrentContactName:nameField.text];
	}
	
	if (sender == numberField)
	{
		[model setCurrentContactNumber:numberField.text];
	}
}

- (IBAction)backgroundTap:(id)sender
{
	// Hide the keyboard
	[nameField resignFirstResponder];
	[numberField resignFirstResponder];
}

#pragma mark -
#pragma mark UIViewController

/*
// Implement loadView to create a view hierarchy programmatically,
// without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view,
// typically from a nib.
- (void)viewDidLoad
{
	[nameField setText:[model currentContactName]];
	[numberField setText:[model currentContactNumber]];
	
	[favoriteSegmentedControl setSelectedSegmentIndex:
		[[model currentContactButton] intValue]];
	oldButton = [[model currentContactButton] copy];
	[favoriteSegmentedControl addTarget:self 
								 action:@selector(favoritesSegmentAction:) 
					   forControlEvents:UIControlEventValueChanged];

	int indexToSelect = 0;
	for (int i = 0; i < [colorSegmentedControl numberOfSegments]; i++)
	{
		if ([[colorSegmentedControl titleForSegmentAtIndex:i] 
			 isEqualToString:[model currentContactColor]])
		{
			indexToSelect = i;
		}
	}
	[colorSegmentedControl setSelectedSegmentIndex:indexToSelect];
	[colorSegmentedControl addTarget:self 
								 action:@selector(colorSegmentAction:) 
					   forControlEvents:UIControlEventValueChanged];
	
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
