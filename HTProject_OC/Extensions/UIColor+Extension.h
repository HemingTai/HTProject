//
//  UIColor+Extension.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Extension)

//! 将十六进制的颜色值转为UIColor
+ (UIColor *)getColorFromHexString:(NSString *)hexColor;

@end
