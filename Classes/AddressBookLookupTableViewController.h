// ------------------------------------------------------------------------
//  AddressBookLookupTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 3/2/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#import "PhoneNumberFormatter.h"
#import "AddAddressProtocol.h"

@class EmergencyNumbersModel;

@interface AddressBookLookupTableViewController : UITableViewController
	<UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView *iconsTableView;
	
	EmergencyNumbersModel *model;
	PhoneNumberFormatter *formatter;
	
	NSMutableArray *availableCallList;
	NSMutableArray *availableCallIndex;
	
	id <AddAddressProtocol> delegate;
}

@property (nonatomic, assign) EmergencyNumbersModel *model;
@property (nonatomic, assign) id<AddAddressProtocol> delegate;

@end


