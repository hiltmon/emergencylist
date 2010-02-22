// ------------------------------------------------------------------------
//  FavoritesViewController.h
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#import "QuickCallButton.h"

@class EmergencyNumbersModel;

@interface FavoritesViewController : UIViewController
{
	QuickCallButton *button1;
	QuickCallButton *button2;
	QuickCallButton *button3;
	QuickCallButton *button4;
	QuickCallButton *button5;
	QuickCallButton *button6;
	UIImageView *startImage;
	
	EmergencyNumbersModel *model;
	NSArray *buttonArray;
	
}

@property (nonatomic, assign) IBOutlet QuickCallButton *button1;
@property (nonatomic, assign) IBOutlet QuickCallButton *button2;
@property (nonatomic, assign) IBOutlet QuickCallButton *button3;
@property (nonatomic, assign) IBOutlet QuickCallButton *button4;
@property (nonatomic, assign) IBOutlet QuickCallButton *button5;
@property (nonatomic, assign) IBOutlet QuickCallButton *button6;
@property (nonatomic, assign) IBOutlet UIImageView *startImage;

- (IBAction) buttonPressed:(id)sender;

@end
