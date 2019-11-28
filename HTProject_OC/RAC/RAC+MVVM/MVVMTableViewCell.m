//
//  MVVMTableViewCell.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "MVVMTableViewCell.h"

@implementation MVVMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 50)];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end
