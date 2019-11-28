//
//  HTTestModel.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/9.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTTestModel.h"
#import <objc/runtime.h>

@implementation HTTestModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        unsigned int count;
        //获取该类的属性列表
        objc_property_t *propertys = class_copyPropertyList([self class], &count);
        for (NSInteger i=0; i<count; i++) {
            objc_property_t p = propertys[i];
            //获取属性名
            const char *name = property_getName(p);
            NSString *keyName = [NSString stringWithUTF8String:name];
            //KVC为该属性赋值
            [self setValue:[dict objectForKey:keyName] forKey:keyName];
        }
        free(propertys);
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name:%@, age:%ld, gender:%d", self.name, self.age, self.male];
}

@end
