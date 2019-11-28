//
//  MVVMHeaderView.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "MVVMHeaderView.h"
#import "HTModel.h"

@implementation MVVMHeaderView

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    if (self.subviews.count)
    {
        for (UILabel *label in self.subviews)
        {
            [label removeFromSuperview];
        }
    }
    [self addLabels];
}

- (void)addLabels
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width/4.0;
    CGFloat height = 60;
    for (NSInteger i=0; i<self.dataArray.count; i++)
    {
        HTModel *model = self.dataArray[i];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i%4*width, i/4*height, width, height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = UIColor.whiteColor;
        titleLabel.backgroundColor = [[UIColor alloc] initWithRed:(arc4random() % 255)/255.0 green:(arc4random() % 255)/255.0 blue:(arc4random() % 255)/255.0 alpha:1];
        titleLabel.text = model.title;
        [self addSubview:titleLabel];
    }
}

@end
