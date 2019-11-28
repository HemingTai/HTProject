//
//  YYTestViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/28.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "YYTestViewController.h"

@interface YYTestViewController ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation YYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view1 = [UIView new];
    self.view1.backgroundColor = UIColor.redColor;
    self.view1.frame = CGRectMake(self.view.centerX-100, 100, 200, 200);
    [self.view1.layer setLayerShadow:UIColor.grayColor offset:CGSizeMake(5, 5) radius:2.5];
    [self.view addSubview:self.view1];
    
    self.imgView = [UIImageView new];
    self.imgView.frame = CGRectMake(self.view.centerX-50, self.view1.top+200+30, 100, 100);
    self.imgView.image = [self.view1.layer snapshotImage];
    [self.view addSubview:self.imgView];
    
    
    
    
    
}

@end
