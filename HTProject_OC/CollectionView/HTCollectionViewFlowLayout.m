//
//  HTCollectionViewFlowLayout.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/12/10.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "HTCollectionViewFlowLayout.h"

@interface HTCollectionViewFlowLayout()

@property (nonatomic, assign) HTAlignmentLayout alignment;
//!item 的高度数组
@property (nonatomic,   copy) NSArray<NSNumber *> *itemHeightArray;
//!item 的宽度数组
@property (nonatomic,   copy) NSArray<NSNumber *> *itemWidthArray;
//!cell 布局属性集
@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *arrAttributes;

@end

@implementation HTCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    switch (self.alignment) {
        case HTAlignmentLayoutLeft: {
            NSParameterAssert(self.itemWidthArray.count);
            NSMutableArray *rowLengthArray = [NSMutableArray array];
            NSMutableArray *rowItemCountArray = [NSMutableArray array];
            NSMutableArray *attrsTemp = [NSMutableArray array];
            NSInteger rowCount = 0, itemCount = 0;
            CGFloat rowLength = self.sectionInset.left;
            CGFloat columHeight = self.sectionInset.top;
            for (NSInteger i = 0; i < self.itemWidthArray.count; i++) {
                // 设置每个item的位置等相关属性
                NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
                // 创建每一个布局属性类，通过indexPath来创建
                UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:index];
                CGRect frame = attrs.frame;
                // 由数组得到的宽度
                frame.size.width = [self.itemWidthArray[i] doubleValue];
                frame.origin.x = rowLength;
                rowLength += [self.itemWidthArray[i] doubleValue] + self.minimumInteritemSpacing;
                itemCount++;
                if (rowLength > self.collectionViewContentSize.width) {
                    [rowLengthArray addObject:@(rowLength-[self.itemWidthArray[i] doubleValue]-self.minimumInteritemSpacing)];
                    rowLength = self.sectionInset.left;
                    frame.origin.x = rowLength;
                    rowLength += [self.itemWidthArray[i] doubleValue] + self.minimumInteritemSpacing;
                    rowCount ++;
                    itemCount--;
                    [rowItemCountArray addObject:@(itemCount)];
                    itemCount = 0;
                    columHeight += self.itemSize.height + self.minimumLineSpacing;
                }
                frame.origin.y = columHeight;
                attrs.frame = frame;
                [attrsTemp addObject:attrs];
            }
            self.arrAttributes = attrsTemp;
            CGFloat maxRowLength = 0, maxItemCount = 0;
            for (NSInteger i=0; i< rowLengthArray.count; i++) {
                CGFloat length = [rowLengthArray[i] doubleValue];
                if (length > maxRowLength) {
                    maxRowLength = length;
                    maxItemCount = [rowItemCountArray[i] integerValue];
                }
            }
            self.itemSize = CGSizeMake((maxRowLength-self.sectionInset.left-self.sectionInset.right+self.minimumInteritemSpacing)/maxItemCount, self.itemSize.height);
        }
            break;
        default:{
            NSParameterAssert(self.itemHeightArray.count);
            // 计算一行可以放多少个item
            NSInteger itemCountInRow = (self.collectionViewContentSize.width-self.sectionInset.left-self.sectionInset.right+self.minimumInteritemSpacing)/(self.itemSize.width+self.minimumInteritemSpacing);
            // 对列的长度进行累计
            NSMutableArray *columnLengthArray = [NSMutableArray array];
            for (NSInteger i = 0; i < itemCountInRow; i++) {
                [columnLengthArray addObject:@0];
            }
            NSMutableArray *arrmTemp = [NSMutableArray array];
            // 遍历设置每一个item的布局
            for (NSInteger i = 0; i < self.itemHeightArray.count; i++) {
                // 设置每个item的位置等相关属性
                NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
                // 创建每一个布局属性类，通过indexPath来创建
                UICollectionViewLayoutAttributes *attris = [self layoutAttributesForItemAtIndexPath:index];
                CGRect recFrame = attris.frame;
                // 由数组得到的高度
                recFrame.size.height = [self.itemHeightArray[i] doubleValue];
                // 最短列序号
                NSInteger nNumShort = 0;
                // 最短的长度
                CGFloat fShortLength = [columnLengthArray[0] doubleValue];
                // 比较是否存在更短的列
                for (int i = 1; i < columnLengthArray.count; i++) {
                    CGFloat fLength = [columnLengthArray[i] doubleValue];
                    if (fLength < fShortLength) {
                        nNumShort = i;
                        fShortLength = fLength;
                    }
                }
                // 插入到最短的列中
                recFrame.origin.x = self.sectionInset.left + (self.itemSize.width + self.minimumInteritemSpacing) * nNumShort;
                recFrame.origin.y = fShortLength + self.minimumLineSpacing;
                // 更新列的累计长度
                columnLengthArray[nNumShort] = [NSNumber numberWithDouble:CGRectGetMaxY(recFrame)];
                // 更新布局
                attris.frame = recFrame;
                [arrmTemp addObject:attris];
            }
            self.arrAttributes = arrmTemp;
                
            // 因为使用了瀑布流布局使得滚动范围是根据 item 的大小和个数决定的，所以以最长的列为基准，将高度平均到每一个 cell 中
            // 最长列序号
            NSInteger nNumLong = 0;
            // 最长的长度
            CGFloat fLongLength = [columnLengthArray[0] doubleValue];
            // 比较是否存在更短的列
            for (int i = 1; i < [columnLengthArray count]; i++) {
                CGFloat fLength = [columnLengthArray[i] doubleValue];
                if (fLength > fLongLength) {
                    nNumLong = i;
                    fLongLength = fLength;
                }
            }
            // 在大小一样的情况下，有多少行
            NSInteger nRows = (self.itemHeightArray.count + itemCountInRow - 1) / itemCountInRow;
            self.itemSize = CGSizeMake(self.itemSize.width, (fLongLength + self.minimumLineSpacing) / nRows - self.minimumLineSpacing);
        }
            break;
    }
}

// 返回所有的 cell 布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.arrAttributes;
}

- (void)flowLayoutWithItemWidth:(CGFloat)itemWidth itemHeightArray:(NSArray<NSNumber *> *)itemHeightArray {
    self.itemSize = CGSizeMake(itemWidth, 0);
    self.alignment = HTAlignmentLayoutVertical;
    self.itemHeightArray = itemHeightArray;
    [self.collectionView reloadData];
}

- (void)flowLayoutWithItemHeight:(CGFloat)itemHeight itemWidthArray:(NSArray<NSNumber *> *)itemWidthArray {
    self.itemSize = CGSizeMake(0, itemHeight);
    self.itemWidthArray = itemWidthArray;
    self.alignment = HTAlignmentLayoutLeft;
    [self.collectionView reloadData];
}

@end
