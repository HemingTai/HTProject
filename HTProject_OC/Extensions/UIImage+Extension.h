//
//  UIImage+Extension.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Extension)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *)resize:(CGSize)size;

- (UIImage *)combineImage:(UIImage *)image;

@end
