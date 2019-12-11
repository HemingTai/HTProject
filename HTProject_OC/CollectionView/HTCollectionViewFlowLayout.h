//
//  HTCollectionViewFlowLayout.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/12/10.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HTAlignmentLayout) {
    HTAlignmentLayoutLeft,
    HTAlignmentLayoutVertical
};

@interface HTCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 垂直瀑布流布局方法
 
 @param itemWidth item 的宽度
 @param itemHeightArray item 的高度数组
 */
- (void)flowLayoutWithItemWidth:(CGFloat)itemWidth itemHeightArray:(NSArray<NSNumber *> *)itemHeightArray;

/**
水平瀑布流布局方法

@param itemHeight item 的高度
@param itemWidthArray item 的宽度数组
*/
- (void)flowLayoutWithItemHeight:(CGFloat)itemHeight itemWidthArray:(NSArray<NSNumber *> *)itemWidthArray;

@end

NS_ASSUME_NONNULL_END
