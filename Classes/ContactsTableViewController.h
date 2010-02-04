// ------------------------------------------------------------------------
//  ContactsTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

//@class ContactsDetailViewController;
@class EmergencyNumbersModel;

@interface ContactsTableViewController : UITableViewController 
	<UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView *contactsTableView;

	EmergencyNumbersModel *model;
}

@end
