// ------------------------------------------------------------------------
//  UIImage_Resize.m
//  EmergencyNumbers
//
//  Created by Hilton Lipschitz on 2/9/10.
//  Copyright 2010 NoVerse.com. All rights reserved.
//
// Thank you http://developers.enormego.com/view/uiimage_resizing_scaling
// ------------------------------------------------------------------------

#import "UIImage_Resize.h"

@implementation UIImage (Resize)

- (UIImage*)scaleToSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, 
		CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

@end
