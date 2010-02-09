// ------------------------------------------------------------------------
//  ColorLookupTableViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/9/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class EmergencyNumbersModel;

@interface ColorLookupTableViewController : UITableViewController
	<UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView *colorsTableView;
	
	EmergencyNumbersModel *model;
}

@property (nonatomic, assign) EmergencyNumbersModel *model;

@end
