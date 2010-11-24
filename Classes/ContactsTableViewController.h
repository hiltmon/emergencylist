// ------------------------------------------------------------------------
//  ContactsTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#import "ItemTableViewController.h"
#import "AddressBookLookupTableViewController.h"
#import "PhoneNumberFormatter.h"

@class EmergencyNumbersModel;

@interface ContactsTableViewController : UITableViewController 
	<UITableViewDataSource, UITableViewDelegate, 
	 UIActionSheetDelegate,
	 AddItemProtocol, AddAddressProtocol>
{
	IBOutlet UITableView *contactsTableView;

	EmergencyNumbersModel *model;
	PhoneNumberFormatter *phoneNumberFormatter;
	
	NSString *tempName;
	NSString *tempNumber;
    UIImage *tempImage;
}

- (void)addNew;

@property (nonatomic, retain) NSString *tempName;
@property (nonatomic, retain) NSString *tempNumber;
@property (nonatomic, retain) UIImage *tempImage;

@end
