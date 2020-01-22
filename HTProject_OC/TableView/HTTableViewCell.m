//
//  HTTableViewCell.m
//  HTProject_OC
//
//  Created by Hem1ngT4i on 2019/12/31.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "HTTableViewCell.h"

@interface HTTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HTTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        self.dataArray = @[@"我是cell",@"我是cell",@"我是cell",@"我是cell",@"我是cell",@"我是cell",@"我是cell",@"我是cell",@"我是cell",@"我是cell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HTTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (@available(iOS 13.0, *)) {
            //暗黑模式自动适配颜色，该颜色由系统提供
            //            cell.backgroundColor = UIColor.systemBackgroundColor;
            //            cell.textLabel.textColor = UIColor.labelColor;
            //暗黑模式手动适配颜色，该颜色由用户提供
            cell.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                //暗黑模式
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return UIColor.blackColor;
                } else {
                    return UIColor.whiteColor;
                }
            }];
            cell.textLabel.textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                //暗黑模式
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return UIColor.whiteColor;
                } else {
                    return UIColor.orangeColor;
                }
            }];
        }
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

@end
