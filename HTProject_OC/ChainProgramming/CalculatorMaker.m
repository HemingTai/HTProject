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
