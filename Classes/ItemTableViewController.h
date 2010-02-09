// ------------------------------------------------------------------------
//  ItemTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/8/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#define kNewItem @"New List Entry"

@class EmergencyNumbersModel;

@protocol ItemAddDelegate;

// Constants for each section in the table view
enum
{
	NameSection,
	ButtonSection
};

@interface ItemTableViewController : UITableViewController
	<UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet UITableView *itemTableView;
	
	EmergencyNumbersModel *model;
	
	id<ItemAddDelegate> delegate;
}

@property (nonatomic, assign) EmergencyNumbersModel *model;
@property (nonatomic, assign) id<ItemAddDelegate> delegate;

@end

@protocol ItemAddDelegate <NSObject>

- (void)contactAddViewController:
	(ItemTableViewController *)ItemTableViewController
                   didAddContact:(BOOL)addedContact;

@end

