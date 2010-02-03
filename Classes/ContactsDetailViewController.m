// ------------------------------------------------------------------------
//  ContactsDetailViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "ContactsDetailViewController.h"

@implementation ContactsDetailViewController

@synthesize nameField;
@synthesize numberField;

@synthesize currentRecord;

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
	
	[nameField dealloc];
	[numberField dealloc];

    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)textFieldDoneEditing:(id)sender
{
	//NSLog(@"ContactsDetailViewController textFieldDoneEditing");
	
	// Hide the keyboard
	[sender resignFirstResponder];
}

- (IBAction)textFieldValueChanged:(id)sender
{
	//NSLog(@"ContactsDetailViewController textFieldValueChanged");
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
	[self.nameField setText:[self.currentRecord valueForKey:@"name"]];
	[self.numberField setText:[self.currentRecord valueForKey:@"number"]];
	
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
