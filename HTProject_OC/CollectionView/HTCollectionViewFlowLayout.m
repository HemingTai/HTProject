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
//!水平靠左布局时总行数
@property (nonatomic, assign) NSInteger rows;
//!垂直靠上布局时最高列
@property (nonatomic, assign) CGFloat maxColumnHeight;
//!item的高度数组
@property (nonatomic,   copy) NSArray<NSNumber *> *itemHeightArray;
//!item的宽度数组
@property (nonatomic,   copy) NSArray<NSNumber *> *itemWidthArray;
//!cell布局属性集
@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *attributesArray;

@end

@implementation HTCollectionViewFlowLayout

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

- (void)flowLayoutWithItemSize:(CGSize)itemSize deltaArray:(NSArray<NSNumber *> *)deltaArray style:(HTAlignmentLayout)alignment {
    self.alignment = alignment;
    switch (alignment) {
        case HTAlignmentLayoutLeft:
            [self flowLayoutWithItemHeight:itemSize.height itemWidthArray:deltaArray];
            break;
        default:
            [self flowLayoutWithItemWidth:itemSize.width itemHeightArray:deltaArray];
            break;
    }
}

//MARK: ------ override ------

- (void)prepareLayout {
    [super prepareLayout];
    switch (self.alignment) {
        case HTAlignmentLayoutLeft:
            NSParameterAssert(self.itemWidthArray.count);
            self.rows = 1;
            self.attributesArray = [self getAlignmentLayoutLeftAttributes];
            break;
        default:
            NSParameterAssert(self.itemHeightArray.count);
            self.attributesArray = [self getAlignmentLayoutVerticalAttributes];
            break;
    }
}

- (CGSize)collectionViewContentSize {
    switch (self.alignment) {
        case HTAlignmentLayoutLeft:
            return CGSizeMake(self.collectionView.bounds.size.width, self.rows*(self.itemSize.height+self.minimumLineSpacing)+self.sectionInset.top + self.sectionInset.bottom-self.minimumLineSpacing);
        default:
            return CGSizeMake(self.collectionView.bounds.size.width, self.maxColumnHeight + self.sectionInset.bottom);
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

//MARK: ------ functions ------

- (NSArray<UICollectionViewLayoutAttributes *> *)getAlignmentLayoutLeftAttributes {
    NSMutableArray *attrsArray = [NSMutableArray array];
    CGFloat rowLength = self.sectionInset.left, columnHeight = self.sectionInset.top;
    for (NSInteger i = 0; i < self.itemWidthArray.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:index];
        CGRect frame = attrs.frame;
        frame.size.width = [self.itemWidthArray[i] doubleValue];
        frame.origin.x = rowLength;
        rowLength += [self.itemWidthArray[i] doubleValue] + self.minimumInteritemSpacing;
        if (rowLength > self.collectionViewContentSize.width) {
            rowLength = self.sectionInset.left;
            frame.origin.x = rowLength;
            rowLength += [self.itemWidthArray[i] doubleValue] + self.minimumInteritemSpacing;
            self.rows ++;
            columnHeight += self.itemSize.height + self.minimumLineSpacing;
        }
        frame.origin.y = columnHeight;
        attrs.frame = frame;
        [attrsArray addObject:attrs];
    }
    return attrsArray.copy;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)getAlignmentLayoutVerticalAttributes {
    //每一行可放item个数
    NSInteger itemsInRow = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing);
    //对列的高度进行累计
    NSMutableArray *columnHeightArray = [NSMutableArray array];
    for (NSInteger i = 0; i < itemsInRow; i++) {
        [columnHeightArray addObject:@(self.sectionInset.top)];
    }
    //设置每个item的相关属性
    NSMutableArray *attrsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.itemHeightArray.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        //通过indexPath来获取每一个cell布局属性类
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:index];
        CGRect frame = attrs.frame;
        frame.size.height = [self.itemHeightArray[i] doubleValue];
        //最短列序号
        NSInteger shortestColumn = 0;
        //最短列高度
        CGFloat shortestColumnHeight = [columnHeightArray[0] doubleValue];
        //比较是否存在更短的列
        for (int i = 1; i < columnHeightArray.count; i++) {
            CGFloat tempHeight = [columnHeightArray[i] doubleValue];
            if (tempHeight < shortestColumnHeight) {
                shortestColumn = i;
                shortestColumnHeight = tempHeight;
            }
        }
        //插入到最短的列中并更新列的累计长度
        frame.origin.x = self.sectionInset.left + (self.itemSize.width + self.minimumInteritemSpacing) * shortestColumn;
        frame.origin.y = shortestColumnHeight + (i < itemsInRow ? 0 : self.minimumLineSpacing);
        attrs.frame = frame;
        [attrsArray addObject:attrs];
        columnHeightArray[shortestColumn] = [NSNumber numberWithDouble:CGRectGetMaxY(frame)];
    }
    //因为使用了瀑布流布局使得滚动范围是根据 item 的大小和个数决定的，所以要获取最长列的高度
    self.maxColumnHeight = [columnHeightArray[0] doubleValue];
    for (int i = 1; i < [columnHeightArray count]; i++) {
        CGFloat tempHeight = [columnHeightArray[i] doubleValue];
        if (tempHeight > self.maxColumnHeight) {
            self.maxColumnHeight = tempHeight;
        }
    }
    return attrsArray.copy;
}

@end
