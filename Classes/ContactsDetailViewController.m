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
@synthesize model;

#pragma mark -

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
	[model save];
}

- (IBAction)textFieldValueChanged:(id)sender
{
	if (sender == nameField)
	{
		[[model currentContact] setName:nameField.text];
	}
	
	if (sender == numberField)
	{
		[[model currentContact] setNumber:numberField.text];
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate Protocol

// Implemented to catch 'next' on keypad
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == nameField)
	{
		[numberField becomeFirstResponder];
	}
	else
	{
		[nameField becomeFirstResponder];
	}

	return NO;
}

#pragma mark -
#pragma mark UIViewController

// Implement viewDidLoad to do additional setup after loading the view,
// typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[nameField setText:[[model currentContact] name]];
	[numberField setText:[[model currentContact] number]];
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	// Edit the name
	[nameField becomeFirstResponder];
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
