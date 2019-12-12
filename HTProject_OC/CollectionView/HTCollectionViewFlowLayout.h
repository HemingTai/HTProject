//
//  HTCollectionViewFlowLayout.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/12/10.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 瀑布流布局方式
typedef NS_ENUM(NSInteger, HTAlignmentLayout) {
    HTAlignmentLayoutVertical, //垂直靠上布局
    HTAlignmentLayoutLeft //水平靠左布局
};

@interface HTCollectionViewFlowLayout : UICollectionViewFlowLayout

/// 瀑布流布局
/// @param itemSize item的大小，
/// @param deltaArray item的宽度或者高度数组
/// @param alignment 布局方式
- (void)flowLayoutWithItemSize:(CGSize)itemSize
                    deltaArray:(NSArray<NSNumber *> *)deltaArray
                         style:(HTAlignmentLayout)alignment;

@end

NS_ASSUME_NONNULL_END
