// ------------------------------------------------------------------------
//  ContactsDetailViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@interface ContactsDetailViewController : UIViewController
{
	UITextField *nameField;
	UITextField *numberField;
	
	NSDictionary *currentRecord;
	
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *numberField;

@property (nonatomic, assign) NSDictionary *currentRecord;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldValueChanged:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
