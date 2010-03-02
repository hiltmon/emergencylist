// ------------------------------------------------------------------------
//  ContactsDetailViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class EmergencyNumbersModel;

@interface ContactsDetailViewController : UIViewController
{
	UITextField *nameField;
	UITextField *numberField;
	
	EmergencyNumbersModel *model;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *numberField;

@property (nonatomic, assign) EmergencyNumbersModel *model;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldValueChanged:(id)sender;

@end