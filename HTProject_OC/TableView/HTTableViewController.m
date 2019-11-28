//
//  HTTableViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/20.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTTableViewController.h"

@interface HTTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerBackView;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HTTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-55) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.headerBackView.backgroundColor = UIColor.redColor;

    self.headerImgView = [[UIImageView alloc] initWithFrame:self.headerBackView.bounds];
    self.headerImgView.image = [UIImage imageWithContentsOfFile:[HTUtility getFilePathFromBundleByName:@"1.jpeg"]];
    [self.headerBackView addSubview:self.headerImgView];
    self.tableView.tableHeaderView = self.headerBackView;
    
    NSArray *array1 = @[@"我是段1",@"我是段1",@"我是段1",@"我是段1",@"我是段1",@"我是段1",@"我是段1",@"我是段1",@"我是段1",@"我是段1"];
    NSArray *array2 = @[@"我是段2",@"我是段2",@"我是段2",@"我是段2",@"我是段2",@"我是段2",@"我是段2",@"我是段2",@"我是段2",@"我是段2"];
    NSArray *array3 = @[@"我是段3",@"我是段3",@"我是段3",@"我是段3",@"我是段3",@"我是段3",@"我是段3",@"我是段3",@"我是段3",@"我是段3"];
    NSArray *array4 = @[@"我是段4",@"我是段4",@"我是段4",@"我是段4",@"我是段4",@"我是段4",@"我是段4",@"我是段4",@"我是段4",@"我是段4"];
    NSArray *array5 = @[@"我是段5",@"我是段5",@"我是段5",@"我是段5",@"我是段5",@"我是段5",@"我是段5",@"我是段5",@"我是段5",@"我是段5"];
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dataArray addObject:array1];
    [self.dataArray addObject:array2];
    [self.dataArray addObject:array3];
    [self.dataArray addObject:array4];
    [self.dataArray addObject:array5];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            NSLog(@"当前是暗黑模式");
        }
    }
}

//MARK: ********* UITableViewDataSource,UITableViewDelegate ********

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.dataArray[section]).count;
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
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //模拟锚点，滚动到指定位置
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //图片高度
    CGFloat imageHeight = self.headerBackView.frame.size.height;
    //图片宽度
    CGFloat imageWidth = self.headerBackView.frame.size.width;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移，模拟头部视图放大效果
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        self.headerImgView.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
    //下移，//模拟头部视图缩小效果
//    if (imageOffsetY > 0) {
//        CGFloat totalOffset = imageHeight - ABS(imageOffsetY);
//        CGFloat f = totalOffset / imageHeight;
//        [self.headerImgView setFrame:CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset)];
//    }
}

@end
