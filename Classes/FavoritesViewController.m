// ------------------------------------------------------------------------
//  FavoritesViewController.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/1/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "QuartzCore/CALayer.h"			// Needed for blending images

#import "FavoritesViewController.h"
#import "EmergencyNumbersAppDelegate.h"	// Needed to get to model
#import "EmergencyNumbersModel.h"

// Private methods
@interface FavoritesViewController ()

- (UIImage *)newImageForColor:(NSString *)myColor
					  andIcon:(NSString *)myIcon;
- (void)setTitle:(NSString *)title 
		   color:(NSString *)myColor 
			icon:(NSString *)myIcon
	   forButton:(UIButton *)button;
- (void)reloadData;

@end

@implementation FavoritesViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize button6;

#pragma mark -

- (void)dealloc
{
	[buttonArray dealloc];
	
    [super dealloc];
}

- (UIImage *)newImageForColor:(NSString *)myColor
					  andIcon:(NSString *)myIcon
{
	NSString *backgroundImageName = 
		[NSString stringWithFormat:@"%@Button.png", myColor];
	UIImage *buttonBackground = [UIImage imageNamed:backgroundImageName];
	
	// Apply the merge
	NSString *iconImageName = 
		[NSString stringWithFormat:@"%@Icon.png", myIcon];
	UIImage* topImage    = [UIImage imageNamed:iconImageName];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:buttonBackground];
	UIImageView* subView   = [[UIImageView alloc] initWithImage:topImage];
	subView.alpha = 0.5;  // Customize the opacity of the top image.
	[imageView addSubview:subView];
	UIGraphicsBeginImageContext(imageView.frame.size);
	[[imageView layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* blendedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[subView release];
	[imageView release];
	
	return blendedImage;
}

// Ugly in API, need to set the title of a button for all states
// TODO: Add comment
- (void)setTitle:(NSString *)title 
		   color:(NSString *)myColor
			icon:(NSString *)myIcon
	   forButton:(UIButton *)button
{
	NSString *modifiedTitle = [NSString stringWithFormat:@"\n\n\n%@", title];
	// Set the title to be the same for ALL states
	[button setTitle:modifiedTitle forState:UIControlStateNormal];
	[button setTitle:modifiedTitle forState:UIControlStateHighlighted];
	[button setTitle:modifiedTitle forState:UIControlStateDisabled];
	[button setTitle:modifiedTitle forState:UIControlStateSelected];
	
	// TODO: Optimize by caching images
	// Create the button backgrounds
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	if ([myColor isEqualToString:@"Yellow"] 
		|| [myColor isEqualToString:@"Cyan"]
		|| [myColor isEqualToString:@"Green"])
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	
	UIImage *blendedImage = [self newImageForColor:myColor andIcon:myIcon];
	[button setBackgroundImage:blendedImage 
					   forState:UIControlStateNormal];
	
	// Pressed is always Gray
	UIImage *pressedImage = [self newImageForColor:@"Gray" andIcon:myIcon];
	[button setBackgroundImage:pressedImage 
					  forState:UIControlStateHighlighted];
	
	// In case the parent draws a back image
	button.backgroundColor = [UIColor clearColor];
}

- (void)reloadData
{
	button1.hidden = YES;
	button2.hidden = YES;
	button3.hidden = YES;
	button4.hidden = YES;
	button5.hidden = YES;
	button6.hidden = YES;
	
	// Set the buttons...
	for (int i = 0; i < [model count]; i++)
	{
		NSInteger whichButton = [[model contactButtonAtIndex:i] intValue];
		if (whichButton > 0)
		{
			[self setTitle:[model contactNameAtIndex:i] 
					 color:[model contactColorAtIndex:i]
					  icon:[model contactIconAtIndex:i]
				 forButton:[buttonArray objectAtIndex:whichButton-1]];
			[[buttonArray objectAtIndex:whichButton-1] setHidden:NO];
		}
	}
}

#pragma mark -
#pragma mark UIViewController

//  Override inherited method to automatically refresh table view's data
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, 
// typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Access the model
	EmergencyNumbersAppDelegate *appDelegate = 
		(EmergencyNumbersAppDelegate *)
			[[UIApplication sharedApplication] delegate];
	model = appDelegate.model;
	
	buttonArray = [[NSArray alloc] initWithObjects:button1, button2,
				   button3, button4, button5, button6, nil];
	
	[self reloadData];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
