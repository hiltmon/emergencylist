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

// Takes a color background and blends on the given image
- (UIImage *)newImageForColor:(NSString *)myColor
					  andImage:(UIImage *)myImage
{
	NSString *backgroundImageName = [NSString stringWithFormat:@"%@Button.png", myColor];
	UIImage *buttonBackground = [UIImage imageNamed:backgroundImageName];
    
	//UIImageView* imageView = [[UIImageView alloc] initWithImage:buttonBackground];
	//UIImageView* subView   = [[UIImageView alloc] initWithImage:myImage];
    
    UIGraphicsBeginImageContext(buttonBackground.size);
    [buttonBackground drawInRect:CGRectMake(0.0, 0.0, buttonBackground.size.width, buttonBackground.size.height)];
    CGFloat left = buttonBackground.size.width / 2.0 - myImage.size.width / 2.0;
    [myImage drawInRect:CGRectMake(left, 10.0, myImage.size.width, myImage.size.height) blendMode:kCGBlendModeNormal alpha:1.0]; //  kCGBlendModeNormal
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	//[subView release];
	//[imageView release];
	
	return blendedImage;
}


// Takes a color background and blends on the given icon
- (UIImage *)newImageForColor:(NSString *)myColor
					  andIcon:(NSString *)myIcon
{
	NSString *backgroundImageName = [NSString stringWithFormat:@"%@Button.png", myColor];
	UIImage *buttonBackground = [UIImage imageNamed:backgroundImageName];
	
	// Apply the merge
	NSString *iconImageName = [NSString stringWithFormat:@"%@Icon.png", myIcon];
	UIImage *topImage    = [UIImage imageNamed:iconImageName];
    
	UIImageView* imageView = [[UIImageView alloc] initWithImage:buttonBackground];
	UIImageView* subView   = [[UIImageView alloc] initWithImage:topImage];
//	subView.alpha = 0.5;  // Customize the opacity of the top image.
//    subView.frame = CGRectMake(0.0, 10.0, subView.frame.size.width, subView.frame.size.height);
//	[imageView addSubview:subView];
//	UIGraphicsBeginImageContext(imageView.frame.size);
//	[[imageView layer] renderInContext:UIGraphicsGetCurrentContext()];
//	UIImage* blendedImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [buttonBackground drawInRect:CGRectMake(0.0, 0.0, imageView.frame.size.width, imageView.frame.size.height)];
    [topImage drawInRect:CGRectMake(0.0, 10.0, subView.frame.size.width, subView.frame.size.height) blendMode:kCGBlendModeNormal alpha:0.5]; //  kCGBlendModeNormal
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
	[subView release];
	[imageView release];
	
	return blendedImage;
}

// Ugly in API, need to set the title of a button for all states
- (void)setTitle:(NSString *)myTitle 
		   color:(NSString *)myColor
			icon:(NSString *)myIcon
           image:(UIImage *)myImage
{
	// Set the title to be the same for ALL states
	[self setTitle:myTitle forState:UIControlStateNormal];
	[self setTitle:myTitle forState:UIControlStateHighlighted];
	[self setTitle:myTitle forState:UIControlStateDisabled];
	[self setTitle:myTitle forState:UIControlStateSelected];
	
	// TODO: Optimize by caching images
	// Create the button backgrounds
    if ([myColor isEqualToString:@"Yellow"] 
        || [myColor isEqualToString:@"Gray"]
        || [myColor isEqualToString:@"Cyan"])
    {
       	[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted]; 
    }
    else
    {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
	
	UIImage *blendedImage;
    if ([myIcon isEqualToString:@"Photo"])
    {
        blendedImage = [self newImageForColor:myColor andImage:myImage];
    }
    else
    {
        blendedImage = [self newImageForColor:myColor andIcon:myIcon];
    }

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
