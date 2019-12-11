//
//  CollectionViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/12/9.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "CollectionViewController.h"
#import "HTCollectionViewFlowLayout.h"

@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HTCollectionViewFlowLayout *layout = [[HTCollectionViewFlowLayout alloc] init];
    // 创建随机高度的数组
    NSMutableArray *arrayHeight = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        // 40～80 的随机高度
        [arrayHeight addObject:[NSNumber numberWithDouble:40 + arc4random() % 40]];
    }
//    [layout flowLayoutWithItemWidth:80 itemHeightArray:arrayHeight];
    // 创建随机宽度的数组
    NSMutableArray *arrayWidth = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        // 40～80 的随机高度
        [arrayWidth addObject:[NSNumber numberWithDouble:40 + arc4random() % 40]];
    }
    [layout flowLayoutWithItemHeight:80 itemWidthArray:arrayWidth];
    // 以最小间距为10计算间距
    CGFloat fSpacing = 10;
    layout.minimumInteritemSpacing = fSpacing;
    layout.minimumLineSpacing = fSpacing;
    layout.sectionInset = UIEdgeInsetsMake(fSpacing, fSpacing, fSpacing, fSpacing);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 83 - 88) collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 注册 cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HTCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTCell" forIndexPath:indexPath];
    // cell 序号
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    if (label == nil) {
        [cell setBackgroundColor:[UIColor cyanColor]];
        label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:80];
        label.adjustsFontSizeToFitWidth = YES;
        label.tag = 10;
        [cell addSubview:label];
    }
    [label setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    label.text = [[NSString alloc] initWithFormat:@"%ld", indexPath.item + 1];
    return cell;
}


@end
