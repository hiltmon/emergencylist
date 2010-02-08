// ------------------------------------------------------------------------
//  FavoritesViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class EmergencyNumbersModel;

@interface FavoritesViewController : UIViewController
{
	UIButton *button1;
	UIButton *button2;
	UIButton *button3;
	UIButton *button4;
	UIButton *button5;
	UIButton *button6;
	
	EmergencyNumbersModel *model;
	NSArray *buttonArray;
}

@property (nonatomic, assign) IBOutlet UIButton *button1;
@property (nonatomic, assign) IBOutlet UIButton *button2;
@property (nonatomic, assign) IBOutlet UIButton *button3;
@property (nonatomic, assign) IBOutlet UIButton *button4;
@property (nonatomic, assign) IBOutlet UIButton *button5;
@property (nonatomic, assign) IBOutlet UIButton *button6;

@end
