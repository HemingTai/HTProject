//
//  UIImage+Extension.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
	return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor {
	return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
	// We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the
	// device’s main screen.
	UIGraphicsBeginImageContextWithOptions (self.size, NO, 0.0f);
	[tintColor setFill];
	CGRect bounds = CGRectMake (0, 0, self.size.width, self.size.height);
	UIRectFill (bounds);

	// Draw the tinted image in context
	[self drawInRect:bounds blendMode:blendMode alpha:1.0f];

	if (blendMode != kCGBlendModeDestinationIn)
    {
		[self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
	}

	UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext ();
	UIGraphicsEndImageContext ();

	return tintedImage;
}

- (UIImage *)resize:(CGSize)size {
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	[self drawInRect:CGRectMake (0, 0, size.width, size.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

//绘制到右下角
- (UIImage *)combineImage:(UIImage *)image {
    CGSize finalSize = [self size];
    
    CGSize  imageSize = CGSizeMake(finalSize.width*2,finalSize.height*2);
    UIGraphicsBeginImageContext (imageSize);
    [self drawInRect:CGRectMake (0, 0,finalSize.width*2,finalSize.height*2)];
    [image drawInRect:CGRectMake (finalSize.width*2-image.size.width*2, finalSize.height*2-image.size.height*2, image.size.width*2,image.size.height*2)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    return [newImage resize:finalSize];
}

@end
