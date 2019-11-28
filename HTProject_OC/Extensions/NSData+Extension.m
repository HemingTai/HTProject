//
//  NSData+Extension.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "NSData+Extension.h"

@implementation NSData(Extension)

- (id)JSONValue {
    NSError *error;
    id value = [NSJSONSerialization JSONObjectWithData:self options:0 error:&error];
    return error ? nil : value;
}

@end
