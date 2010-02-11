// ------------------------------------------------------------------------
//  IconLookupTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/11/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class EmergencyNumbersModel;

@interface IconLookupTableViewController : UITableViewController
	<UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView *iconsTableView;
	
	EmergencyNumbersModel *model;
}

@property (nonatomic, assign) EmergencyNumbersModel *model;

@end
