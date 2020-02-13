//
//  CalculatorMaker.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/29.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import "CalculatorMaker.h"

/************************** 链式编程 **********************/

@implementation CalculatorMaker

- (CalculatorBlock)add
{
    return ^CalculatorMaker *(int value) {
        //在访问对象的时候，self.和self->是一样的,都是访问对象本身;
        //当这个对象声明为属性，self.属性等于调用set/get方法，而self->属性，就是调用这个属性的对象本身即_属性
        self->_result += value;
        return self;
    };
}

- (CalculatorBlock)sub
{
    return ^CalculatorMaker *(int value) {
        self->_result -= value;
        return self;
    };
}

- (CalculatorBlock)multi
{
    return ^CalculatorMaker *(int value) {
        self->_result *= value;
        return self;
    };
}

- (CalculatorBlock)divide
{
    return ^CalculatorMaker *(int value) {
        self->_result /= value;
        return self;
    };
}

@end
