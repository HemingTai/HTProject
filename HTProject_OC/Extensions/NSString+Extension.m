//
//  NSData+Extension.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "HTUtility.h"

@implementation NSString (Extension)

- (id)JSONValue {
    NSError *error;
    id value = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    return error ? nil : value;
}

- (NSString *)MD5Value {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5 (cStr, (CC_LONG)strlen (cStr), result);

    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i != sizeof (result) / sizeof (unsigned char); ++i)
    {
        [resultString appendFormat:@"%02X", result[i]]; // %02X：大写，%02x：小写
    }
    return resultString;
}

@end
