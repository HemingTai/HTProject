//
//  CalculatorMaker.h
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/29.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CalculatorMaker;

typedef CalculatorMaker *_Nonnull(^CalculatorBlock)(int);

@interface CalculatorMaker : NSObject

@property(nonatomic, assign) int result;

- (CalculatorBlock)add;

- (CalculatorBlock)sub;

- (CalculatorBlock)multi;

- (CalculatorBlock)divide;

@end

NS_ASSUME_NONNULL_END
