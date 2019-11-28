//
//  DictionaryViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/22.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "DictionaryViewController.h"

@interface DictionaryViewController ()

@end

@implementation DictionaryViewController

//MARK: ---------- LifeCycle ----------

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self myTestFunction1];
    [self myTestFunction2];
}

- (void)myTestFunction1
{
    /****************************************** NSDictionary底层实现 ************************************************
     * NSDictionary（字典）是使用 hash表来实现key和value之间的映射和存储的，首先内部会去调用 key 对象的 hash 方法确定 object 在hash表内的入口位置，然后会调用 isEqual 来确定该值是否已经存在于 NSDictionary中。
     * 问iOS中setValue和setObject的区别：
     - (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;
     - (void)setValue:(nullable ObjectType)value forKey:(NSString *)key;
     
     (1) setObject: ForKey:是NSMutableDictionary特有的；setValue: ForKey:是KVC的主要方法。
     (2) setValue: ForKey:的value是可以为nil的（但是当value为nil的时候，会自动调用removeObject：forKey方法）；setObject: ForKey:的value则不可以为nil。
     (3) setValue: ForKey:的key必须是不为nil的字符串类型；setObject: ForKey:的key可以是不为nil的所有继承NSCopying的类型。
     **************************************************************************************************************/
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:nil forKey:@"1"];
    //    [dic setObject:nil forKey:@"2"];
    [dic setObject:@"" forKey:@"3"];
    //[NSNull null]是一个oc对象，并不是nil
    [dic setObject:[NSNull null] forKey:@"4"];
    NSLog(@"dic --- %@", dic);
}

- (void)myTestFunction2 {
    //对于字典，如果取值得key不存在，则结果就是null，不会导致崩溃
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[@"1",@"2",@"3"],@[@"a",@"b",@"c"], nil];
    NSLog(@"--%@",mdic[@"4"]);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@[@"1",@"2",@"3",@""],@[@"a",@"b",@"c",@"d"], nil];
    NSLog(@"--%@",dic[@"5"]);
}

@end
