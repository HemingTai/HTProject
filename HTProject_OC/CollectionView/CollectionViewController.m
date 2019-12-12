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
    CGFloat fSpacing = 10;
    layout.minimumInteritemSpacing = fSpacing;
    layout.minimumLineSpacing = fSpacing;
    layout.sectionInset = UIEdgeInsetsMake(fSpacing, fSpacing, fSpacing, fSpacing);
    //创建变量数组
    NSMutableArray *delatArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        [delatArray addObject:[NSNumber numberWithDouble:40 + arc4random() % 40]];
    }
    [layout flowLayoutWithItemSize:CGSizeMake(60, 60) deltaArray:delatArray style:HTAlignmentLayoutLeft];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 83 - 88) collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.blackColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HTCell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTCell" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    if (!label) {
        [cell setBackgroundColor:[UIColor orangeColor]];
        label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:30];
        label.adjustsFontSizeToFitWidth = YES;
        label.tag = 10;
        [cell.contentView addSubview:label];
    }
    [label setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    label.text = [[NSString alloc] initWithFormat:@"%ld", indexPath.item + 1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--%@",indexPath);
}
@end
