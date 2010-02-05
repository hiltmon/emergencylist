// ------------------------------------------------------------------------
//  ContactsTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#import "ContactsDetailViewController.h"

//@class ContactsDetailViewController;
@class EmergencyNumbersModel;

@interface ContactsTableViewController : UITableViewController 
	<UITableViewDataSource, UITableViewDelegate, ContactAddDelegate>
{
	IBOutlet UITableView *contactsTableView;

	EmergencyNumbersModel *model;
	EmergencyNumbersModel *newModel;
}

@end
