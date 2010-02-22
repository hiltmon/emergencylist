// ------------------------------------------------------------------------
//  QuickCallButton.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/22/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
// ------------------------------------------------------------------------

#import "QuickCallButton.h"

#import "QuartzCore/CALayer.h"			// Needed for blending images

@interface QuickCallButton ()

- (UIImage *)newImageForColor:(NSString *)myColor
					  andIcon:(NSString *)myIcon;

@end

@implementation QuickCallButton

#pragma mark -
#pragma mark Methods

// Takes a color background and blends on the given icon
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
- (void)setTitle:(NSString *)myTitle 
		   color:(NSString *)myColor
			icon:(NSString *)myIcon
{
	// Set the title to be the same for ALL states
	[self setTitle:myTitle forState:UIControlStateNormal];
	[self setTitle:myTitle forState:UIControlStateHighlighted];
	[self setTitle:myTitle forState:UIControlStateDisabled];
	[self setTitle:myTitle forState:UIControlStateSelected];
	
	// TODO: Optimize by caching images
	// Create the button backgrounds
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	
	UIImage *blendedImage = [self newImageForColor:myColor andIcon:myIcon];
	[self setBackgroundImage:blendedImage 
					forState:UIControlStateNormal];
	//[blendedImage release];
	
	// Pressed is always Gray
	UIImage *pressedImage = [self newImageForColor:@"Gray" andIcon:myIcon];
	[self setBackgroundImage:pressedImage 
					forState:UIControlStateHighlighted];
	//[pressedImage release];
	
	// In case the parent draws a back image
	self.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark Overrides

// Overrides the drawing of the button by moving the UILabel to half its size
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	UILabel *titleLabel = [self titleLabel];
	CGRect fr = [titleLabel frame];
	fr.origin.x = 15;
	fr.origin.y = 80;
	fr.size.width = 130;
	fr.size.height = 57;
	[titleLabel setFrame:fr];
	[titleLabel setMinimumFontSize:12.0];
	[titleLabel setAdjustsFontSizeToFitWidth:YES];
	[titleLabel setTextAlignment:UITextAlignmentCenter];
}

@end
