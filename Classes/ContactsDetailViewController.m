// ------------------------------------------------------------------------
//  ContactsDetailViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ContactsDetailViewController.h"
#import "EmergencyNumbersModel.h"

@implementation ContactsDetailViewController

@synthesize nameField;
@synthesize numberField;
@synthesize favoriteSegmentedControl;
@synthesize colorSegmentedControl;

@synthesize currentRecord;
@synthesize model;

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
	// Clear outlets or [CALayer release] tries to release these again
	nameField = nil;
	numberField = nil;
	favoriteSegmentedControl = nil;
	colorSegmentedControl = nil;
	
	[nameField dealloc];
	[numberField dealloc];
	[favoriteSegmentedControl dealloc];
	[colorSegmentedControl dealloc];

    [super dealloc];
}

- (void)favoritesSegmentAction:(id)sender
{
	NSLog(@"ContactsDetailViewController favoritesSegmentAction");
	
	// Need to remove this button from any other contacts
	
	NSString *whichButton = [NSString stringWithFormat:@"%d", 
							 [favoriteSegmentedControl selectedSegmentIndex]];
	[self.model clearButton:whichButton];
	[self.currentRecord setValue:whichButton forKey:@"button"];
	
	[self.model save];
	
}

- (void)colorSegmentAction:(id)sender
{
	NSLog(@"ContactsDetailViewController colorSegmentAction");
	NSString *whichColor = [NSString stringWithFormat:@"%@", 
		 [colorSegmentedControl titleForSegmentAtIndex:[
				colorSegmentedControl selectedSegmentIndex]]];
	[self.currentRecord setValue:whichColor forKey:@"color"];
	
	[self.model save];
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)textFieldDoneEditing:(id)sender
{
	NSLog(@"ContactsDetailViewController textFieldDoneEditing");
	
	// Hide the keyboard
	[sender resignFirstResponder];
	
	[self.model save];
}

- (IBAction)textFieldValueChanged:(id)sender
{
	NSLog(@"ContactsDetailViewController textFieldValueChanged");
	if (sender == nameField)
	{
		[self.currentRecord setValue:nameField.text forKey:@"name"];
	}
	
	if (sender == numberField)
	{
		[self.currentRecord setValue:numberField.text forKey:@"number"];
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
	[nameField setText:[self.currentRecord valueForKey:@"name"]];
	[numberField setText:[self.currentRecord valueForKey:@"number"]];
	
	[favoriteSegmentedControl setSelectedSegmentIndex:
		[[self.currentRecord valueForKey:@"button"] intValue]];
	[favoriteSegmentedControl addTarget:self 
								 action:@selector(favoritesSegmentAction:) 
					   forControlEvents:UIControlEventValueChanged];

	int indexToSelect = 0;
	for (int i = 0; i < [colorSegmentedControl numberOfSegments]; i++)
	{
		if ([[colorSegmentedControl titleForSegmentAtIndex:i] 
			 isEqualToString:[self.currentRecord valueForKey:@"color"]])
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
