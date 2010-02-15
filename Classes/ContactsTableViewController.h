// ------------------------------------------------------------------------
//  ContactsTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ItemTableViewController.h"

//@class ContactsDetailViewController;
@class EmergencyNumbersModel;

@interface ContactsTableViewController : UITableViewController 
	<UITableViewDataSource, UITableViewDelegate, 
	 UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate,
	 ItemAddDelegate>
{
	IBOutlet UITableView *contactsTableView;

	EmergencyNumbersModel *model;
	
	NSString *tempName;
	NSString *tempNumber;
}

- (void)addNew;

@property (nonatomic, retain) NSString *tempName;
@property (nonatomic, retain) NSString *tempNumber;

@end
