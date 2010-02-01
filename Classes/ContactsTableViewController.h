// ------------------------------------------------------------------------
//  ContactsTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class ContactsDetailViewController;

@interface ContactsTableViewController : UITableViewController 
	<UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView *contactsTableView;
	
	NSMutableArray *contactsArray;
	ContactsDetailViewController *contactsDetailViewController;
}

@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) 
	ContactsDetailViewController *contactsDetailViewController;

@end
