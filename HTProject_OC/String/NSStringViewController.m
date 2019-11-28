//
//  NSStringViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/2.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "NSStringViewController.h"

@interface NSStringViewController ()

@property (nonatomic, copy) NSString *name1;

@property (nonatomic, copy) NSMutableString *name2;

@end

@implementation NSStringViewController

//MARK: ---------- LifeCycle ----------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string1 = @"abc";
    self.name1 = string1;
    NSLog(@"string1:%@ %p----name1:%@ %p",string1,string1,self.name1,self.name1);
    string1 = @"bcd";
    NSLog(@"string1:%@ %p----name1:%@ %p",string1,string1,self.name1,self.name1);
    self.name1 = string1.copy;
    NSLog(@"string1:%@ %p----name1:%@ %p",string1,string1,self.name1,self.name1);
    self.name1 = string1.mutableCopy;
    NSLog(@"string1:%@ %p----name1:%@ %p",string1,string1,self.name1,self.name1);
    
    NSMutableString *string2 = [NSMutableString stringWithString:@"xyz"];
    self.name1 = string2;
    NSLog(@"string2:%@ %p----name1:%@ %p",string2,string2,self.name1,self.name1);
    [string2 appendString:@"mn"];
    NSLog(@"string2:%@ %p----name1:%@ %p",string2,string2,self.name1,self.name1);
    self.name1 = string2.copy;
    NSLog(@"string2:%@ %p----name1:%@ %p",string2,string2,self.name1,self.name1);
    self.name1 = string2.mutableCopy;
    NSLog(@"string2:%@ %p----name1:%@ %p",string2,string2,self.name1,self.name1);
    NSString *nString = string2.mutableCopy;
    NSLog(@"nString:%@ %p----name1:%@ %p",nString,nString,self.name1,self.name1);
    
    
    
    
    NSString *string3 = @"opq";
    self.name2 = string3;
    NSLog(@"string3:%@ %p----name2:%@ %p",string3,string3,self.name2,self.name2);
    string3 = @"jkl";
    NSLog(@"string3:%@ %p----name2:%@ %p",string3,string3,self.name2,self.name2);
    self.name2 = string3.copy;
    NSLog(@"string3:%@ %p----name2:%@ %p",string3,string3,self.name2,self.name2);
    self.name2 = string3.mutableCopy;
    NSLog(@"string3:%@ %p----name2:%@ %p",string3,string3,self.name2,self.name2);
    
    NSMutableString *string4 = [NSMutableString stringWithString:@"rst"];
    self.name2 = string4;
    NSLog(@"string4:%@ %p----name2:%@ %p",string4,string4,self.name2,self.name2);
    [string4 appendString:@"ef"];
    NSLog(@"string4:%@ %p----name2:%@ %p",string4,string4,self.name2,self.name2);
    self.name2 = string4.copy;
    NSLog(@"string4:%@ %p----name2:%@ %p",string4,string4,self.name2,self.name2);
    self.name2 = string4.mutableCopy;
    NSLog(@"string4:%@ %p----name2:%@ %p",string4,string4,self.name2,self.name2);
    
    
    NSString *string5 = nil;
    NSString *string6 = nil;
    // '=='比较的是两者的地址是否相同
    if (string5 == string6) {
        NSLog(@"-------1相等--------");
    } else {
        NSLog(@"-------1不相等--------");
    }
    // 'isEqualToString'比较的是两者的值是否相同，但前提是必须是NSString类型调用，而nil并不是NSString类型
    if ([string5 isEqualToString:string6]) {
        NSLog(@"-------2相等--------");
    } else {
        NSLog(@"-------2不相等--------");
    }
}

@end
