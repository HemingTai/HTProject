//
//  UIColor+Extension.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor(Extension)

+ (UIColor *)getColorFromHexString:(NSString *)hexColor {
    unsigned int redInt, greenInt, blueInt;
    NSRange range;
    range.length = 2;
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    // 取红色的值
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&redInt];
    // 取绿色的值
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&greenInt];
    // 取蓝色的值
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blueInt];
    return [UIColor colorWithRed:(float)(redInt/255.0f) green:(float)(greenInt/255.0f) blue:(float)(blueInt/255.0f) alpha:1.0f];
}


@end
