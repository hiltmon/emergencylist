// ------------------------------------------------------------------------
//  ContactsDetailViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class EmergencyNumbersModel;

@protocol ContactAddDelegate;

@interface ContactsDetailViewController : UIViewController
{
	UITextField *nameField;
	UITextField *numberField;
	UISegmentedControl *favoriteSegmentedControl;
	UISegmentedControl *colorSegmentedControl;
	
	EmergencyNumbersModel *model;
	NSString *oldButton;
	
	id<ContactAddDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *numberField;
@property (nonatomic, retain) IBOutlet 
	UISegmentedControl *favoriteSegmentedControl;
@property (nonatomic, retain) IBOutlet 
	UISegmentedControl *colorSegmentedControl;

@property (nonatomic, assign) EmergencyNumbersModel *model;

@property (nonatomic, assign) id<ContactAddDelegate> delegate;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldValueChanged:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end

@protocol ContactAddDelegate <NSObject>

- (void)contactAddViewController:
	(ContactsDetailViewController *)contactsDetailViewController
                   didAddContact:(BOOL)addedContact;

@end
